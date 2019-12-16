# -*- coding: utf-8 -*-
#!/usr/bin/env python
#================================================================
#   
#   
#   文件名称：gen_frame_pos_list.py
#   创 建 者：肖飞
#   创建日期：2019年12月16日 星期一 14时32分56秒
#   修改日期：2019年12月16日 星期一 15时18分35秒
#   描    述：
#
#================================================================
import sys
import re
import datetime

def main(argv):
    argv = sys.argv[1:]
    #options = optparse.OptionParser()
    #options.add_option('-d', '--duration', dest='duration', help='duration', default=None)
    #opts, args = options.parse_args(argv)
    #logger.debug('opts:%s' %(opts))
    #logger.debug('args:%s' %(args))
    #if len(args):
    #    options.print_help()
    #    return

    #if not opts.duration:
    #    return
    if len(argv) != 1:
        return

    p = re.compile('^([0-9]+):([0-9]+):([0-9]+)$')
    m = re.match(p, argv[0])
    if not m:
        return

    #print m.groups()
    start = datetime.datetime.strptime('0:0:0', '%H:%M:%S')
    end = datetime.datetime.strptime('%s:%s:%s' %(m.groups()), '%H:%M:%S')
    delta = end - start
    seconds = int(delta.total_seconds())

    step = seconds / 15

    for i in range(0, seconds, step):
        dt = start + datetime.timedelta(0, i)
        print dt.strftime('%H:%M:%S')

if '__main__' == __name__:
    main(sys.argv[1:])
