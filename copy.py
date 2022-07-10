import os
import shutil

packages = '/Users/drunk/Documents/java/timenote_pc/packages/'
notus = packages + 'notus'
zefyr = packages + 'zefyr'
markdown = packages + 'markdown'
flutter_markdown = packages + 'flutter_markdown'


# 移除文件夹
def removeFodler(folderPath):
    print(folderPath)
    if os.path.exists(folderPath):
        shutil.rmtree(folderPath, onerror=readonly_handler)


def readonly_handler(func, path, execinfo):
    os.chmod(path, 128)  # or os.chmod(path, stat.S_IWRITE) from "stat" module
    func(path)


# 拷贝文件夹
def copyFodler(srcFolder, destFodler):
    if os.path.exists(srcFolder):
        shutil.copytree(srcFolder, destFodler)
    print(srcFolder)


def replaceFolder(srcFolder, destFolder):
    removeFodler(destFolder)
    copyFodler(srcFolder, destFolder)


if __name__ == '__main__':
    replaceFolder("packages/notus", notus)
    replaceFolder("packages/markdown", markdown)
    replaceFolder("packages/zefyr", zefyr)
    replaceFolder("packages/flutter_markdown", flutter_markdown)
