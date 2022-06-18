
type # Little-endian types
  ule16* = distinct uint16
  ule32* = distinct uint32
  ule64* = distinct uint64

template borrow(typ) =
  func `$`*(a: typ): string {.borrow.}
  func `==`*(a, b: typ): bool {.borrow.}
  func `shr`*(x, y: typ): typ {.borrow.}
  func `shr`*(x: typ; y: int): typ =
    x shr y.typ
  func `and`*(x, y: typ): typ {.borrow.}
  func `and`*(x: typ; y: int): typ =
    x and y.typ

borrow ule16
borrow ule32
borrow ule64

# const
#   version* = (4,0)
#   magic* = 0x73717368'u32

#   # size of metadata (inode and directory) blocks
#   metaDataSize* = 8192'u32
#   metaDataLog* = 13'u32

#   # default size of data blocks
#   fileSize* = 131072'u32
#   fileLog* = 17'u32

#   fileMaxSize* = 1048576'u32
#   fileMaxLog* = 20'u32

#   # Max number of uids and gids
#   maxIds* = 65536'u32

#   # Max length of filename (not 255)
#   nameMaxLen* = 256'u32

#   invalidFrag* = 0xffffffff'u32
#   invalidBlock* = -1'i64

# type # enums
#   FilesystemFlags* {.size: sizeof(ule16), pure.} = enum
#     Noi = 0
#     Nod = 1
#     # hole
#     Nof = 3
#     NoFrag = 4
#     AlwaysFrag = 5
#     Duplicate = 6
#     Export = 7

#   FileKind* {.size: sizeof(ule16), pure.} = enum
#     Dir = 1
#     File
#     SymLink
#     Block
#     Char
#     Fifo
#     Socket
#     XDir
#     XFile
#     XSymLink
#     XBlock
#     XChar
#     XFifo
#     XSocket
