import
  std/re,
  pkg/nup

let subsPass1 = [
  (re"u64", "uint64"),
  (re"LL'i64", "'i64"),
  (re"__le16", "ule16"),
  (re"__le32", "ule32"),
  (re"__le64", "ule64"),
  (re"""importc: "[^"]+",\s+header: "[^"]+",\s+""", ""),
  (re""" \{\.importc: "[^"]+"\.\}""", ""),
  (re"""bycopy,\s+""", ""),
  (re"CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE", "3'u64"),
  (re"cuchar", "char")
]
let subsPass2 = [
  (re""" \{\.bycopy\.\}""", ""),
]

const squashfs_c2nim_preamble = """
include squashfs_preamble
"""

make({RunImmediately}):
  "squashfs-tools" <= git ("https://github.com/plougher/squashfs-tools",
                           "62a8a93f84b169955054dc086e5024ef4895ad17",
                           ["kernel/kernel-2.6/fs/squashfs/squashfs_fs.h"])

  "squashfs_c2nim.nim" <= "squashfs-tools/kernel/kernel-2.6/fs/squashfs/squashfs_fs.h":
    shell &"c2nim --concat --skipcomments --skipinclude --header -o={outputName.quoteShell} {paths.quoteShellAndJoin}"
    writeFile outputName, squashfs_c2nim_preamble & multiReplace(multiReplace(readFile outputName, subsPass1), subsPass2)
