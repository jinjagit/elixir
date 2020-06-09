# A binary is a chunk of bytes

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
