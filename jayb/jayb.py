#!/usr/bin/env python
# encoding: utf-8
'''
@author:     jayb

@copyright:  2017 jayb. All rights reserved.

@license:    jayb

@contact:    631078133@qq.com
'''

import sys
import os
import subprocess

statusFile = "repository_status"

def usage():
    print("""
    Usage Like This: {} encode/decode keyword
    """.format(sys.argv[0].split("/")[-1]))

def fileList(dirRoot="..",ignorefileordirlist=["README.md","jayb",".git"]):
    filelist=[]
    for pathContext in os.walk(dirRoot):
        if len(pathContext[2]) is not 0:
            for file in pathContext[2]:
                filelist.append(pathContext[0]+os.sep+file)
    return(segmentation(filelist,[dirRoot+os.sep+path for path in ignorefileordirlist]))
    
def segmentation(fileList,filesOrDirs):
    fileListSet=fileList
    ignoreFileList,ignoreDirList=distinction(filesOrDirs)
    for item in ignoreDirList:
        for context in fileListSet:
            if context.startswith(item) and context[len(item)]==os.sep:
                ignoreFileList.append(context)
    for item in ignoreFileList:
        fileListSet.pop(fileListSet.index(item))
    return(fileListSet)

def distinction(filesOrDirs):
    files=[]
    dirs=[]
    for item in filesOrDirs:
        if os.path.isdir(item):
            dirs.append(item)
        elif os.path.isfile(item):
            files.append(item)
        else:
            pass
    return(files,dirs)

def operate(operation,fileList,passwd):
    if operation=="decode" and statusFileOperate(operation, "read")=="encode":
        for filePath in fileList:
            decryption(operation, filePath, passwd)
        statusFileOperate(operation, "write")
    if operation=="encode" and statusFileOperate(operation, "read")=="decode":
        for filePath in fileList:
            encryption(operation, filePath, passwd)
        statusFileOperate(operation, "write")
def encryption(operation,filePath,passwd):
    encryption_cmd="openssl enc -des3 -a -salt -k {passwd} -in {filePath} -out {filePath}.cov".format(**locals())
    subprocess.call(encryption_cmd,shell=True)
    updateFile(operation, filePath)
def decryption(operation,filePath,passwd):
    decryption_cmd="openssl enc -d -des3 -a -salt -k {passwd} -in {filePath} -out {filePath}.rec".format(**locals())
    subprocess.call(decryption_cmd,shell=True)
    updateFile(operation, filePath)
def updateFile(operation,filePath):
    if operation=="decode":
        os.remove(filePath)
        os.rename(filePath+".rec", filePath)
    if operation=="encode":
        os.remove(filePath)
        os.rename(filePath+".cov", filePath)
def statusFileOperate(operation,case):
    if case=="read":
        with open(statusFile,"r") as status:
            return(status.read())
    if case=="write":
        with open(statusFile,"w") as status:
            status.write(operation)      

if __name__ == "__main__":
    if len(sys.argv) != 3:
        usage()
        sys.exit(1)
    operations = ["encode","decode"]
    operation = sys.argv[1]
    passwd = sys.argv[2]
    if operation not in operations:
        usage()
        sys.exit(1)
    operate(operation, fileList(), passwd)
    