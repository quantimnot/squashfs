# https://github.com/plougher/squashfs-tools
# https://dr-emann.github.io/squashfs/squashfs.html
# https://www.kernel.org/doc/html/latest/filesystems/squashfs.html

import
  std/[macros, tables, os, re, pegs, sequtils, terminal, memfiles],
  pkg/[ast_pattern_matching, procs, yaml, mustache, nimgraphviz,
       zero_functional, itertools, trees/avl, prelude],
  squashfs_c2nim


# type # primary layout
#   SuperBlock* = object
#   CompressionOptions* = object
#   DataBlocks* = object
#   InodeTable* = object
#   DirectoryTable* = object
#   FragmentTable* = object
#   ExportTable* = object
#   UidGidTable* = object
#   XattrTable* = object



  # FileTree* = ref object
  #   tree*: AVLTree[int, FileNode]
  # FileNode* = ref object
  #   kind*: FileKind
  #   modTime*: int64
  #   name*: string
  # DirEntry* = ref object
  #   offset*: Le16
  #   inodeNumber*: Le16
  #   kind*: FileKind
  #   size*: Le16
  #   name*: string

type
  Squashfs* = object
    file*: MemFile
    super*: ptr squashfs_super_block

proc openSquashfs*(path: string): Squashfs =
  let file = memfiles.open(path, fmRead)
  let bytes = cast[ptr UncheckedArray[byte]](file.mem)

  let magic = cast[ptr typeof(ule32)](addr bytes[0])[]
  doAssert magic == SQUASHFS_MAGIC.ule32

  result = Squashfs(
    file: file,
    super: cast[ptr squashfs_super_block](addr bytes[0])
  )


proc printFlags*(sqfs: Squashfs) =
  echo "SQUASHFS_UNCOMPRESSED_INODES " & $SQUASHFS_UNCOMPRESSED_INODES sqfs.super.flags
  echo "SQUASHFS_UNCOMPRESSED_DATA " & $SQUASHFS_UNCOMPRESSED_DATA sqfs.super.flags
  echo "SQUASHFS_UNCOMPRESSED_FRAGMENTS " & $SQUASHFS_UNCOMPRESSED_FRAGMENTS sqfs.super.flags
  echo "SQUASHFS_NO_FRAGMENTS " & $SQUASHFS_NO_FRAGMENTS sqfs.super.flags
  echo "SQUASHFS_ALWAYS_FRAGMENTS " & $SQUASHFS_ALWAYS_FRAGMENTS sqfs.super.flags
  echo "SQUASHFS_DUPLICATES " & $SQUASHFS_DUPLICATES sqfs.super.flags
  echo "SQUASHFS_EXPORTABLE " & $SQUASHFS_EXPORTABLE sqfs.super.flags

func `$`*(sqfs: Squashfs): string =
  $sqfs.super[]

let sqfs = openSquashfs "t.sqsh"

printFlags sqfs

print sqfs.super