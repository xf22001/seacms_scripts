# -*- coding: utf-8 -*-
#!/usr/bin/env python
#================================================================
#   
#   
#   文件名称：gen_playlist_db.py
#   创 建 者：肖飞
#   创建日期：2019年12月12日 星期四 11时38分14秒
#   修改日期：2020年02月25日 星期二 13时34分16秒
#   描    述：
#
#================================================================
import sys
import optparse
import os
import re
import datetime
import time

def datetime_to_timestamps(y, m, d, H, M, S):
    dt = datetime.datetime(y, m, d, H, M, S)
    timestamp = time.mktime(dt.timetuple())
    print(int(timestamp))
    return int(timestamp)

class pinyin(object):
    database_file = 'convert-utf-8.txt'
    database = None
    
    def __init__(self, database_file = None):
        print('self.database_file:%s' %(self.database_file))
        if database_file:
            if isinstance(database_file, 'str'):
                self.database_file = database_file

        if os.access(self.database_file, os.F_OK):
            with open(self.database_file) as f:
                self.database = f.read().splitlines()

    def convert_ch(self, ch):
        ret = None

        if isinstance(ch, unicode):
            ch = ch.encode('utf-8')

        b = buffer(ch)
        if len(b) == 1:
            ret = ch.decode('utf-8')
            ret = re.sub('[ ]', '', ret)
            ret = re.sub('[-]', '_', ret)
            return ret

        for i in self.database:
            if ch in i:
                ret = i.replace(ch, '')
                break
        if not ret:
            ret = '_'
        else:
            ret = re.sub(',.*', '', ret)
            ret = re.sub('[0-9]', '', ret)
        return ret
    
    def convert_content(self, content):
        ret = ''
        if not isinstance(content, unicode):
            content = content.decode('utf-8')
        for i in content:
            ch = self.convert_ch(i)
            if ch:
                ret += ch
        return ret

def test():
    py = pinyin()
    content = py.convert_content('《猫》- 卜桦')
    print('%s' %(content))

def parse_filelist(filelist):
    video_tid = 2
    sea_data_sample = "(pattern_index, %d, 'pattern_name', 0, 'pattern_gif', 'pattern_pic', 'pattern_pic', 0, 0, 0, 0, 0, 0, 0, 0, '内详', '', 'pattern_ts_year', '', pattern_ts, 0, '', '', '_', 0, 0, '内详', 'pattern_pinyin', '', 0, 0, '%s', '', '', '', 0, 0, 0, '', '', 0, 0, 0, pattern_ts, pattern_ts, pattern_ts, '', '', '', '', '')" %(video_tid, video_tid)
    sea_playdata_sample = "(pattern_index, %d, 'Dplayer播放$$第1集$pattern_path$dp', '')" %(video_tid)
    sea_content_sample = "(pattern_index, %d, '')" %(video_tid)

    py = pinyin()
    list_sea_data = []
    list_sea_playdata = []
    list_sea_content = []

    item_index = 1
    for i in open(filelist):
        p = re.compile('([0-9]+),(.*)')
        m = re.match(p, i.strip())
        ts, file_path = m.groups()
        file_path = file_path.replace("'", "\\'")
        #print(file_path)
        #file_pic = '%s%s%s' %('/thumbnails', file_path, '.jpg')
        #print(file_pic)
        file_gif = '%s%s%s' %('/gifs', file_path, '.gif')
        #print(file_gif)
        file_name = os.path.splitext(os.path.basename(file_path))[0]
        #print(file_name)
        file_pinyin = py.convert_content(file_name).encode('utf-8')
        #print(file_pinyin)

        sea_data_item = sea_data_sample.replace('pattern_name', file_name)
        sea_data_item = sea_data_item.replace('pattern_gif', file_gif)
        sea_data_item = sea_data_item.replace('pattern_pic', file_gif)
        sea_data_item = sea_data_item.replace('pattern_pinyin', file_pinyin)
        sea_data_item = sea_data_item.replace('pattern_index', str(item_index))
        sea_data_item = sea_data_item.replace('pattern_ts_year', '%s' %(datetime.datetime.fromtimestamp(int(ts)).year))
        sea_data_item = sea_data_item.replace('pattern_ts', ts)
        #print(sea_data_item)
        list_sea_data.append(sea_data_item)

        sea_playdata_item = sea_playdata_sample.replace('pattern_path', file_path)
        sea_playdata_item = sea_playdata_item.replace('pattern_index', str(item_index))
        #print(sea_playdata_item)
        list_sea_playdata.append(sea_playdata_item)

        sea_content_item = sea_content_sample.replace('pattern_index', str(item_index))
        #print(sea_content_item)
        list_sea_content.append(sea_content_item)

        item_index += 1

    sea_data = ''
    for i, item in enumerate(list_sea_data):
        if i == len(list_sea_data) - 1:
            sea_data += '%s;\n' %(item)
        else:
            sea_data += '%s,\n' %(item)

    sea_playdata = ''
    for i, item in enumerate(list_sea_playdata):
        if i == len(list_sea_playdata) - 1:
            sea_playdata += '%s;\n' %(item)
        else:
            sea_playdata += '%s,\n' %(item)

    sea_content = ''
    for i, item in enumerate(list_sea_content):
        if i == len(list_sea_content) - 1:
            sea_content += '%s;\n' %(item)
        else:
            sea_content += '%s,\n' %(item)

    f_pattern = open('pattern.sql')
    pattrn_conten = f_pattern.read()
    f_pattern.close()

    pattrn_conten = pattrn_conten.replace('sea_data_items_pattern', sea_data)
    pattrn_conten = pattrn_conten.replace('sea_playdata_items_pattern', sea_playdata)
    pattrn_conten = pattrn_conten.replace('sea_content_items_pattern', sea_content)

    f_seacms = open('seacms.sql', 'w')
    f_seacms.write(pattrn_conten)
    f_seacms.close()

    #datetime_to_timestamps(2019, 12, 11, 22, 39, 11)

def main(argv):
    options = optparse.OptionParser()
    options.add_option('-f', '--file', dest='filelist', help='filelist', default=None)
    opts, args = options.parse_args(argv)
    print('opts:%s' %(str(opts).decode('string_escape')))
    print('args:%s' %(str(args).decode('string_escape')))
    if len(args):
        options.print_help()
        return

    if not opts.filelist:
        options.print_help()
        return

    parse_filelist(opts.filelist)

if '__main__' == __name__:
    main(sys.argv[1:])
