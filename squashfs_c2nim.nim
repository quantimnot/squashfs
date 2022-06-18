include squashfs_preamble


const
  SQUASHFS_CACHED_FRAGMENTS* = 3'u64
  SQUASHFS_MAJOR* = 4
  SQUASHFS_MINOR* = 0
  SQUASHFS_MAGIC* = 0x73717368
  SQUASHFS_START* = 0


const
  SQUASHFS_METADATA_SIZE* = 8192
  SQUASHFS_METADATA_LOG* = 13


const
  SQUASHFS_FILE_SIZE* = 131072
  SQUASHFS_FILE_LOG* = 17
  SQUASHFS_FILE_MAX_SIZE* = 1048576
  SQUASHFS_FILE_MAX_LOG* = 20


const
  SQUASHFS_IDS* = 65536


const
  SQUASHFS_NAME_LEN* = 256
  SQUASHFS_INVALID_FRAG* = (0xffffffff)
  SQUASHFS_INVALID_BLK* = (-1'i64)


const
  SQUASHFS_NOI* = 0
  SQUASHFS_NOD* = 1
  SQUASHFS_NOF* = 3
  SQUASHFS_NO_FRAG* = 4
  SQUASHFS_ALWAYS_FRAG* = 5
  SQUASHFS_DUPLICATE* = 6
  SQUASHFS_EXPORT* = 7

template SQUASHFS_BIT*(flag, bit: untyped): untyped =
  ((flag shr bit) and 1)

template SQUASHFS_UNCOMPRESSED_INODES*(flags: untyped): untyped =
  SQUASHFS_BIT(flags, SQUASHFS_NOI)

template SQUASHFS_UNCOMPRESSED_DATA*(flags: untyped): untyped =
  SQUASHFS_BIT(flags, SQUASHFS_NOD)

template SQUASHFS_UNCOMPRESSED_FRAGMENTS*(flags: untyped): untyped =
  SQUASHFS_BIT(flags, SQUASHFS_NOF)

template SQUASHFS_NO_FRAGMENTS*(flags: untyped): untyped =
  SQUASHFS_BIT(flags, SQUASHFS_NO_FRAG)

template SQUASHFS_ALWAYS_FRAGMENTS*(flags: untyped): untyped =
  SQUASHFS_BIT(flags, SQUASHFS_ALWAYS_FRAG)

template SQUASHFS_DUPLICATES*(flags: untyped): untyped =
  SQUASHFS_BIT(flags, SQUASHFS_DUPLICATE)

template SQUASHFS_EXPORTABLE*(flags: untyped): untyped =
  SQUASHFS_BIT(flags, SQUASHFS_EXPORT)


const
  SQUASHFS_DIR_TYPE* = 1
  SQUASHFS_REG_TYPE* = 2
  SQUASHFS_SYMLINK_TYPE* = 3
  SQUASHFS_BLKDEV_TYPE* = 4
  SQUASHFS_CHRDEV_TYPE* = 5
  SQUASHFS_FIFO_TYPE* = 6
  SQUASHFS_SOCKET_TYPE* = 7
  SQUASHFS_LDIR_TYPE* = 8
  SQUASHFS_LREG_TYPE* = 9
  SQUASHFS_LSYMLINK_TYPE* = 10
  SQUASHFS_LBLKDEV_TYPE* = 11
  SQUASHFS_LCHRDEV_TYPE* = 12
  SQUASHFS_LFIFO_TYPE* = 13
  SQUASHFS_LSOCKET_TYPE* = 14


const
  SQUASHFS_COMPRESSED_BIT* = (1 shl 15)

template SQUASHFS_COMPRESSED_SIZE*(B: untyped): untyped =
  (if ((B) and not SQUASHFS_COMPRESSED_BIT): (B) and not SQUASHFS_COMPRESSED_BIT else: SQUASHFS_COMPRESSED_BIT)

template SQUASHFS_COMPRESSED*(B: untyped): untyped =
  (not ((B) and SQUASHFS_COMPRESSED_BIT))

const
  SQUASHFS_COMPRESSED_BIT_BLOCK* = (1 shl 24)

template SQUASHFS_COMPRESSED_SIZE_BLOCK*(B: untyped): untyped =
  ((B) and not SQUASHFS_COMPRESSED_BIT_BLOCK)

template SQUASHFS_COMPRESSED_BLOCK*(B: untyped): untyped =
  (not ((B) and SQUASHFS_COMPRESSED_BIT_BLOCK))


template SQUASHFS_INODE_BLK*(A: untyped): untyped =
  (cast[cuint](((A) shr 16)))

template SQUASHFS_INODE_OFFSET*(A: untyped): untyped =
  (cast[cuint](((A) and 0xffff)))

template SQUASHFS_MKINODE*(A, B: untyped): untyped =
  (cast[clonglong](((cast[clonglong]((A)) shl 16) + (B))))


template SQUASHFS_MODE*(A: untyped): untyped =
  ((A) and 0xfff)


template SQUASHFS_FRAGMENT_BYTES*(A: untyped): untyped =
  ((A) * sizeof(squashfs_fragment_entry))

template SQUASHFS_FRAGMENT_INDEX*(A: untyped): untyped =
  (SQUASHFS_FRAGMENT_BYTES(A) div SQUASHFS_METADATA_SIZE)

template SQUASHFS_FRAGMENT_INDEX_OFFSET*(A: untyped): untyped =
  (SQUASHFS_FRAGMENT_BYTES(A) mod SQUASHFS_METADATA_SIZE)

template SQUASHFS_FRAGMENT_INDEXES*(A: untyped): untyped =
  ((SQUASHFS_FRAGMENT_BYTES(A) + SQUASHFS_METADATA_SIZE - 1) div
      SQUASHFS_METADATA_SIZE)

template SQUASHFS_FRAGMENT_INDEX_BYTES*(A: untyped): untyped =
  (SQUASHFS_FRAGMENT_INDEXES(A) * sizeof((uint64)))


template SQUASHFS_LOOKUP_BYTES*(A: untyped): untyped =
  ((A) * sizeof((uint64)))

template SQUASHFS_LOOKUP_BLOCK*(A: untyped): untyped =
  (SQUASHFS_LOOKUP_BYTES(A) div SQUASHFS_METADATA_SIZE)

template SQUASHFS_LOOKUP_BLOCK_OFFSET*(A: untyped): untyped =
  (SQUASHFS_LOOKUP_BYTES(A) mod SQUASHFS_METADATA_SIZE)

template SQUASHFS_LOOKUP_BLOCKS*(A: untyped): untyped =
  ((SQUASHFS_LOOKUP_BYTES(A) + SQUASHFS_METADATA_SIZE - 1) div
      SQUASHFS_METADATA_SIZE)

template SQUASHFS_LOOKUP_BLOCK_BYTES*(A: untyped): untyped =
  (SQUASHFS_LOOKUP_BLOCKS(A) * sizeof((uint64)))


template SQUASHFS_ID_BYTES*(A: untyped): untyped =
  ((A) * sizeof(cuint))

template SQUASHFS_ID_BLOCK*(A: untyped): untyped =
  (SQUASHFS_ID_BYTES(A) div SQUASHFS_METADATA_SIZE)

template SQUASHFS_ID_BLOCK_OFFSET*(A: untyped): untyped =
  (SQUASHFS_ID_BYTES(A) mod SQUASHFS_METADATA_SIZE)

template SQUASHFS_ID_BLOCKS*(A: untyped): untyped =
  ((SQUASHFS_ID_BYTES(A) + SQUASHFS_METADATA_SIZE - 1) div SQUASHFS_METADATA_SIZE)

template SQUASHFS_ID_BLOCK_BYTES*(A: untyped): untyped =
  (SQUASHFS_ID_BLOCKS(A) * sizeof((uint64)))


const
  SQUASHFS_CACHED_BLKS* = 8
  SQUASHFS_MAX_FILE_SIZE_LOG* = 64
  SQUASHFS_MAX_FILE_SIZE* = (1'i64 shl (SQUASHFS_MAX_FILE_SIZE_LOG - 2))
  SQUASHFS_MARKER_BYTE* = 0xff


const
  SQUASHFS_META_INDEXES* = (SQUASHFS_METADATA_SIZE div sizeof(cuint))
  SQUASHFS_META_ENTRIES* = 127
  SQUASHFS_META_SLOTS* = 8

type
  meta_entry* = object
    data_block*: uint64
    index_block*: cuint
    offset*: cushort
    pad*: cushort

  meta_index* = object
    inode_number*: cuint
    offset*: cuint
    entries*: cushort
    skip*: cushort
    locked*: cushort
    pad*: cushort
    meta_entry*: array[SQUASHFS_META_ENTRIES, meta_entry]



const
  ZLIB_COMPRESSION* = 1

type
  squashfs_super_block* = object
    s_magic*: ule32
    inodes*: ule32
    mkfs_time*: ule32
    block_size*: ule32
    fragments*: ule32
    compression*: ule16
    block_log*: ule16
    flags*: ule16
    no_ids*: ule16
    s_major*: ule16
    s_minor*: ule16
    root_inode*: ule64
    bytes_used*: ule64
    id_table_start*: ule64
    xattr_table_start*: ule64
    inode_table_start*: ule64
    directory_table_start*: ule64
    fragment_table_start*: ule64
    lookup_table_start*: ule64

  squashfs_dir_index* = object
    index*: ule32
    start_block*: ule32
    size*: ule32
    name*: UncheckedArray[char]

  squashfs_base_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32

  squashfs_ipc_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32
    nlink*: ule32

  squashfs_dev_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32
    nlink*: ule32
    rdev*: ule32

  squashfs_symlink_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32
    nlink*: ule32
    symlink_size*: ule32
    symlink*: UncheckedArray[char]

  squashfs_reg_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32
    start_block*: ule32
    fragment*: ule32
    offset*: ule32
    file_size*: ule32
    block_list*: UncheckedArray[ule16]

  squashfs_lreg_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32
    start_block*: ule64
    file_size*: ule64
    sparse*: ule64
    nlink*: ule32
    fragment*: ule32
    offset*: ule32
    xattr*: ule32
    block_list*: UncheckedArray[ule16]

  squashfs_dir_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32
    start_block*: ule32
    nlink*: ule32
    file_size*: ule16
    offset*: ule16
    parent_inode*: ule32

  squashfs_ldir_inode* = object
    inode_type*: ule16
    mode*: ule16
    uid*: ule16
    guid*: ule16
    mtime*: ule32
    inode_number*: ule32
    nlink*: ule32
    file_size*: ule32
    start_block*: ule32
    parent_inode*: ule32
    i_count*: ule16
    offset*: ule16
    xattr*: ule32
    index*: UncheckedArray[squashfs_dir_index]

  squashfs_inode* {.union.} = object
    base*: squashfs_base_inode
    dev*: squashfs_dev_inode
    symlink*: squashfs_symlink_inode
    reg*: squashfs_reg_inode
    lreg*: squashfs_lreg_inode
    dir*: squashfs_dir_inode
    ldir*: squashfs_ldir_inode
    ipc*: squashfs_ipc_inode

  squashfs_dir_entry* = object
    offset*: ule16
    inode_number*: ule16
    `type`*: ule16
    size*: ule16
    name*: UncheckedArray[char]

  squashfs_dir_header* = object
    count*: ule32
    start_block*: ule32
    inode_number*: ule32

  squashfs_fragment_entry* = object
    start_block*: ule64
    size*: ule32
    unused*: cuint

