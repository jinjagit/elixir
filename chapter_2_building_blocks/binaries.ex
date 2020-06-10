# A bitstring is a chunk of bits
# A binary is a chunk of bytes
# A binary is a special case of a bitstring that is always aligned to the byte size
# ... and where that byte size results in bit length that is a multiple of 8
# (pedantic, since only a one or 2 bit byte is not such a byte, but theoretically
# <<1::2>> would not be a binary)

binary = <<259>>
# <<259>> is truncated to the byte size (default = 8 bits)
IO.inspect(binary) #=> <<3>>

binary = <<515>>
# <<515>> is thus also truncated similarly
IO.inspect(binary) #=> <<3>>



binary = <<259::16>>
# <<259::16>> specifies 16 bits of consecutive memory space, as 2 * 8 bit bytes,
# thus the first byte represents 256 bits, the second byte the remaining 3 bits.
# Each byte is still 2^8 bits, NOT one larger 2^16 byte, even though a 2^8 bit byte
# is a convention, not a universal standard.
IO.inspect(binary) #=> <<1, 3>>

binary = <<515::16>>
# <<515::16>> (also) specifies 16 bits of consecutive memory space,
# thus the first byte represents 2*256 bits, the second byte the remaining 3 bits
IO.inspect(binary) #=> <<2, 3>>

binary = <<19::4>>
IO.inspect(binary) #=> <<3::size(4)>>

not_a_binary = <<1::2>> # see pedantic note above
IO.inspect(not_a_binary) #=> <<1::size(2)>>

binary = <<112, 259>>
IO.inspect(binary) #=> <<112, 3>>

binary = <<1::4, 15::4>>
# <<1::4, 15::4>> results in a value expressed in a 8 bit form, where 0001 (1) is
# concatenated with 1111 (15), giving 0001111 (31) in 8 bit form
IO.inspect(binary) #=> <<31>>

bitstring = <<1::1, 0::1, 1::1>>
# If the total size of all the values isn’t a multiplier of 8,
# the binary is called a bitstring — a sequence of bits:
IO.inspect(bitstring) #=> <<5::size(3)>>

# binaries and bitstrings can be concatenated using <>
binary = <<1, 2>> <> <<3, 4>>
IO.inspect(binary) #=> <<5::size(3)>>
