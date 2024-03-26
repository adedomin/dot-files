#!/usr/bin/env python3
import boto3
from sys import stderr
from datetime import timedelta, datetime, timezone
from argparse import ArgumentParser


parse_args = ArgumentParser(description='Delete objects from s3 of a certain age') 
parse_args.add_argument('-d', '--delete',
                        action='store_true',
                        dest='delete_for_real',
                        help='Actually delete files')
parse_args.add_argument('-v', '--verbose',
                        action='store_true',
                        dest='verbose',
                        help='more debug output')
parse_args.add_argument('-q', '--quiet',
                        action='store_true',
                        dest='quiet',
                        help='do not output anything')
parse_args.add_argument('bucket',
                        nargs=1,
                        help='the bucket to store')
parse_args.add_argument('-p', '--prefix',
                        dest='prefix',
                        help='the prefix to limit checking over')
parse_args.add_argument('time_policy',
                        nargs='+',
                        help='Policy to use to remove files.\n'
                             'You can write as many as applicable.\n'
                             'Can use <int>(s)econds\n'
                             '             (m)inutes\n'
                             '             (h)ours\n'
                             '             (d)ays\n'
                             '             (w)eeks\n')


args = parse_args.parse_args()


# parse time policy
valid_bases = {'s': 'seconds',
               'm': 'minutes',
               'h': 'hours',
               'd': 'days',
               'w': 'weeks'}
time_policy = dict()
for tpol in args.time_policy:
    for tp in tpol.split():
        num = int(tp[:-1])
        base = tp[-1:]
        if base not in valid_bases:
            raise TypeError('Invalid Base: {}, see --help for valid bases'
                            .format(base))
        time_policy[valid_bases[base]] = num


some_time_ago = datetime.now(tz=timezone.utc) - timedelta(**time_policy)
if args.verbose:
    print('Debug: Deleting objects older than {}'.format(some_time_ago),
          file=stderr)


s3client = boto3.client('s3')
list_pager = s3client.get_paginator('list_objects_v2')
list_pager_args = {'Bucket': args.bucket[0]}
if args.prefix:
    list_pager_args['Prefix'] = args.prefix
if args.verbose:
    print('Debug: list_objects_v2 parameters: {}'.format(list_pager_args),
          file=stderr)
pages = list_pager.paginate(**list_pager_args)


delete_targets = {'Objects': []}
for s3obj in pages.search('Contents'):
    if s3obj is None:
        print('Error: no such prefix {{ {} }} or no objects in bucket.'
              .format(args.prefix),
              file=stderr)
        break

    last_modified = s3obj['LastModified'].replace(tzinfo=timezone.utc)
    if last_modified < some_time_ago:
        if not args.quiet:
            print('Deleting: {} (Age: {})'.format(s3obj['Key'],
                                                  s3obj['LastModified']))
        if args.delete_for_real:
            delete_targets['Objects'].append({'Key': s3obj['Key']})

    if len(delete_targets['Objects']) == 1000 and args.delete_for_real:
        s3client.delete_objects(Bucket=args.bucket[0], Delete=delete_targets)
        delete_targets = {'Objects': []}
else:
    if len(delete_targets['Objects']) and args.delete_for_real:
        s3client.delete_objects(Bucket=args.bucket[0], Delete=delete_targets)
