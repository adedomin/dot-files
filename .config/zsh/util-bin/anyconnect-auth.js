#!/usr/bin/gjs

imports.gi.versions.Gtk = '3.0';

const Gtk = imports.gi.Gtk;
const GLib = imports.gi.GLib;
const WebKit = imports.gi.WebKit2;
const Lang = imports.lang;

Gtk.init(null);

const AnyConnectAuthenticator = new Lang.Class({
    Name: 'AnyConnectAuthenticator',
    Extends: Gtk.Application,
    _init: function() {
        this.parent({
            application_id: 'space.ghetty.AnyconnectAuthenticator',
        });
        // Connect 'activate' and 'startup' signals to the callback functions
        this.connect('startup', Lang.bind(this, this._onStartup));
        this.connect('activate', Lang.bind(this, this._onActivate));
    },

    // Callback function for 'activate' signal 
    _onActivate: function() {
        // Present window when active
        this._window.present();

        // Load the default home page when active
        this._webView.load_uri(ARGV[0]);
        this._webView.get_inspector().show();
    },

    // Callback function for 'startup' signal
    _onStartup: function() {
        // Build the UI
        this._buildUI();

        // Connect the UI signals
        this._connectSignals();
    },

    // Build the application's UI
    _buildUI: function() {
        // Create the application window
        this._window = new Gtk.ApplicationWindow({
            application: this,
            window_position: Gtk.WindowPosition.CENTER,
            default_height: 768,
            default_width: 1024,
            border_width: 0,
            title: "AnyConnect Authentication."
        });
        // Create the WebKit WebView, our window to the web
        this._webContext = new WebKit.WebContext();
        this._webView = new WebKit.WebView({
            web_context: this._webContext,
        });
        // Create a scrolled window to embed the WebView
        let scrolledWindow = new Gtk.ScrolledWindow({
            hscrollbar_policy: Gtk.PolicyType.AUTOMATIC,
            vscrollbar_policy: Gtk.PolicyType.AUTOMATIC
        });
        scrolledWindow.add(this._webView);
        // Create a box to organize everything in
        let box = new Gtk.Box({
            orientation: Gtk.Orientation.VERTICAL,
            homogeneous: false,
            spacing: 0
        });
        box.pack_start(scrolledWindow, true, true, 0);
        // Add the box to the window
        this._window.add(box);
        // Show the window and all child widgets
        this._window.show_all();
    },

    _connectSignals: function() {
        // Change the Window title when a new page is loaded
        this._webView.connect('notify::title', () => {
            this._window.set_title(this._webView.title);
        });

        const cookies = this._webContext.get_cookie_manager();
        cookies.set_persistent_storage(`${GLib.getenv('XDG_DATA_HOME')}/anyconnect-authenticator.txt`,
            WebKit.CookiePersistentStorage.TEXT);
        cookies.connect('changed', (cookies) => {
            const uri = this._webView.get_uri();
            if (/\/\+webvpn\+\/index.html$/.test(uri)) {
                cookies.get_cookies(uri, null, (cookies, res) => {
                    const cookie = cookies.get_cookies_finish(res);
                    cookie.forEach(c => {
                        if (c.get_name() === 'webvpn') {
                            print(c.get_value());
                        }
                    });
                    this.quit();
                });
            }
        });
    },
});

// Run the application
let app = new AnyConnectAuthenticator();
app.run([]);
