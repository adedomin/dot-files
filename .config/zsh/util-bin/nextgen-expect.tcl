#!/usr/bin/expect -f
proc parse_config {filename} {
    # define config defaults
    global serial_dev
    global baud_rate
    global serial_parity
    global serial_databits
    global serial_stopbits
    global username
    global passwd
    global shell_prompt
    global keyfile_contents
    upvar 0 ::env(HOME) homedir

    set serial_dev /dev/ttyUSB0
    set baud_rate 115200
    set serial_parity n
    set serial_databits 8
    set serial_stopbits 1
    set username root
    set passwd set_me_in_the_config
    set shell_prompt {#}
    set keyfile_contents ""

    # for log debug
    set line_num 1
    
    if {[catch {open $filename r} fd]} {
        return
    }

    while {![eof $fd]} {
        # read line
        set line [string trim [gets $fd] " "]
        
        # ignore comments and empty lines
        if {$line == ""} continue
        if {[string match {[#]*} $line]} continue
        
        # split to kv pairs around =
        set kv [split $line =]
        set key [string trim [lindex $kv 0] " "]
        set val [string trim [lindex $kv 1] " "]

        set line_errno "($line_num - $line)"

        switch -- $key {
            serial_port {
                set serial_dev $val
            }
            baud_rate {
                set baud_rate $val
            }
            parity {
                switch -- $val {
                    odd  { set serial_parity o }
                    even { set serial_parity e }
                    none { set serial_parity n }
                    default {
                        error "Error parity not valid: ($val), must be even, odd or none. $line_errno"
                    }
                }
            }
            databits {
                if {$val > 8 && $val < 5} {
                    error "Error databits invalid: 5 <= ($val) <= 8. $line_errno"
                }
                set serial_databits $val
            }
            stopbits {
                if {$val > 2 && $val < 1} {
                    error "Error stopbits invalid: 1 <= ($val) <= 2. $line_errno"
                }
                set serial_stopbits $val
            }
            password {
                set passwd $val
            }
            username {
                set username $val
                if {$username != "root"} {
                    set shell_prompt {$}
                }
            }
            ssh_keyfile {
                set keyfile_fd [open [string map "~ $homedir" $val]]
                set keyfile_contents '[regsub -all {'} [string trim [read $keyfile_fd]] {'\''}]'
                close $keyfile_fd
            }
            default {
                error "Error no such key: ($key) in $filename at $line_errno."
            }
        }
        incr line_num
    }
    close $fd
}

proc enter_pass { username pass shell_prompt key } {
    send "\r"
    while {1} {
        expect {
            "Login incorrect" {
                return false
            }
            "*$shell_prompt" {
                send {old=$(stty -g);}
                send {stty raw -echo min 0 time 5;}
                send {printf '\033[18t' > /dev/tty;}
                send {IFS=';t' read -r _ rows cols _ < /dev/tty;}
                send {stty "$old";}
                send {stty cols "$cols" rows "$rows";}
                send {unset old cols rows;}
                send {shopt -s checkwinsize;}
                if {$key != ""} {
                    send {mkdir -p -m 0700 ~/.ssh;}
                    send [concat {printf '%s\n' } $key { > ~/.ssh/authorized_keys;}]
                }
                send {clear;}
                send {printf '%s\n' 'Connection Set Up.' 'Type Ctrl-a k to quit.';}
                send "\r"
                return true
            }
            "* login:" {
                send "root\r"
            }
            "Password:" {
                send "$pass\r"
            }
        }
    }
}

# global start
set timeout 5

if {[info exists $env(XDG_CONFIG_HOME)]} {
    set config_file "$env(XDG_CONFIG_HOME)/nextgen-expect.conf"
} else {
    set config_file "$env(HOME)/.config/nextgen-expect.conf"
}

parse_config $config_file

set serial_channel [open $serial_dev w+]
fconfigure $serial_channel -mode "$baud_rate,$serial_parity,$serial_databits,$serial_stopbits"
spawn -open $serial_channel
stty sane

if {[enter_pass $username $passwd $shell_prompt $keyfile_contents]} {
    interact {
        \x01k {
            send "\r\x04"
            exit
        }
    }
} else {
    puts "Failed to login."
    exit 1
}
