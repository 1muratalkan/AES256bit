# ----------------------------------------------------------------------------------
# Company: --
# Engineer: Murat ALKAN
# Create Date: 23/02/2024 
# Completion Date: 07/03/2024
# Design Name: aes256.py
# Project Name: 256 Bit ADVANCED ENCRYPTION STANDARD (AES) Algotithm 
# Description: 256 Bitlik Aes sifreleme algoritmasinin python da aes kütüphanesi ile test edilmesi islemi
# Revision: Revision 0.01 - File Created
# Additional Comments:
#----------------------------------------------------------------------------------
s_box_table = [
    # 0    1    2    3    4    5    6    7    8    9    a    b    c    d    e    f
    0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76, # 0
    0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0, # 1
    0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15, # 2
    0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75, # 3
    0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84, # 4
    0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf, # 5
    0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8, # 6
    0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2, # 7
    0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73, # 8
    0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb, # 9
    0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79, # a
    0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08, # b
    0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a, # c
    0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e, # d
    0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf, # e
    0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16  # f
]

Rcon_table = [0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40]

#XOR function--------------------------------------------------------------------------------------
def xor(start_of_round,round_key_value):
    output = start_of_round ^ round_key_value
    return output

#Select functions-----------------------------------------------------------------------------------
def select7(sel_input,row,column): # 256 bitlik keylerimizi secmemiz icin bir secim fonksiyonu olusturduk.
    shift1 = 7 - column 
    shift2 = 3 - row
    return((sel_input>>(shift1*32 + shift2*8))%2**8)

def select(sel_input,row,column): # 128 bitlik verilerimizi secmemiz icin bir secim fonksiyonu olusturduk.
    shift1 = 3 - column 
    shift2 = 3 - row
    return((sel_input>>(shift1*32 + shift2*8))%2**8)

def GF_two(state_in): # In the polynomial representation, multiplication in GF(2**8) for two 
    if state_in >> 7 == 1:
        a = state_in<<1 ^ 0x11b
    elif state_in >> 7 == 0:
        a = state_in << 1
    return a

def GF_three(state_in): # In the polynomial representation, multiplication in GF(2**8) for three 
    if state_in >> 7 ==1 :
        a = (state_in ^ (state_in <<1) ) ^ 0x11b
    elif state_in >> 7 ==0:
        a = state_in ^ (state_in <<1) 
    return a

#Key Selection ----------------------------------------------------------------
def Key1 (key256_in): # 256 bitlik keylerimin ilk 128 bitini secmek icin Key1 fonksiyonu olusturdum
    return (key256_in>>128)

def Key2 (key256_2): # 256 bitlik keylerimin son 128 bitini secmek icin Key2 fonksiyonu olusturdum
    return (key256_2 % 2**128)

#SubBytes function---------------------------------------------------------------------------------
def SubBytes(state_in):
    state_out=0
    for i in range(4):
        for j in range(4):
            byte = (select(state_in,j,i))  #128 bitlik girisimizi 8 bit-8 bit (1 bayt) olarak ayirdik
            s_box_splitted = s_box_table[byte]  #Ayirma isleminden sonra s_box dan cekme islemi yaptik
            state_out = (state_out << 8) + s_box_splitted  #Byte byte olan degerlerimizi 128 bit olacak sekilde birlesirdik
    return state_out

#ShiftRows function---------------------------------------------------------------------------------
def ShiftRows(state_in): #ShiftRows islemini gerceklestirdik. Yapisini anlamak icin dokumana bakabilirsiniz.(NIST AES dokumani)
    state_out = select(state_in,0,0)
    state_out = (state_out << 8) + select(state_in,1,1)
    state_out = (state_out << 8) + select(state_in,2,2)
    state_out = (state_out << 8) + select(state_in,3,3)
    state_out = (state_out << 8) + select(state_in,0,1)
    state_out = (state_out << 8) + select(state_in,1,2)
    state_out = (state_out << 8) + select(state_in,2,3)
    state_out = (state_out << 8) + select(state_in,3,0)
    state_out = (state_out << 8) + select(state_in,0,2)
    state_out = (state_out << 8) + select(state_in,1,3)
    state_out = (state_out << 8) + select(state_in,2,0)
    state_out = (state_out << 8) + select(state_in,3,1)
    state_out = (state_out << 8) + select(state_in,0,3)
    state_out = (state_out << 8) + select(state_in,1,0)
    state_out = (state_out << 8) + select(state_in,2,1)
    state_out = (state_out << 8) + select(state_in,3,2)
    return state_out

#MixColumns function--------------------------------------------------------------------------------------
def MixColumns(state_in):
    state_out=0
    for i in range(4):
        state_out = (state_out << 8) +(GF_two(select(state_in,0,i)) ^ GF_three(select(state_in,1,i)) ^ select(state_in,2,i) ^ select(state_in,3,i))   
        state_out = (state_out << 8) +(select(state_in,0,i) ^ GF_two(select(state_in,1,i)) ^ GF_three(select(state_in,2,i)) ^ select(state_in,3,i))
        state_out = (state_out << 8) +(select(state_in,0,i) ^ select(state_in,1,i) ^ GF_two(select(state_in,2,i)) ^ GF_three(select(state_in,3,i)))
        state_out = (state_out << 8) +(GF_three(select(state_in,0,i)) ^ select(state_in,1,i) ^ select(state_in,2,i) ^ GF_two(select(state_in,3,i)))
    return state_out

#KeyExpansion function for Encryption-----------------------------------------------------------------------------
def KeyExpansion(state_in,i):
    
    #RotWord() islemi ve ardindan S_Boxdan cekilmesi
    RotWord = 0
    RotWord = (RotWord << 8) + s_box_table[select7(state_in,1,7)]
    RotWord = (RotWord << 8) + s_box_table[select7(state_in,2,7)]
    RotWord = (RotWord << 8) + s_box_table[select7(state_in,3,7)]
    RotWord = (RotWord << 8) + s_box_table[select7(state_in,0,7)]

    Rcon = Rcon_table[i]  << 24 

    #kutumdan cekme islemleri
    w0 = state_in>>224 #256 bitlik degerimin w0 4x1 matrixine ulastim.  [en anlamli bitine (MSB) ulastim]
    key_0 = w0 ^ RotWord ^ Rcon # w0 kutumu (en sol 4x1 matrix 32 bit) ve RotWord() islemimi ve Rcon_table da gerekli olan degerimi xor'ladim ve key_0 olarak yeni bir 4x1 matrix tanimladim.

    w1 = ((state_in >> 192)%2**32)#256 bitlik degerimin w1 4x1 matrixine ulastim.
    key_1 = w1 ^ key_0 # yandaki degerlerimi xor'ladim ve key_1 olarak yeni bir 4x1 matrix tanimladim
    
    w2 = ((state_in >> 160)%2**32)#256 bitlik degerimin w2 4x1 matrixine ulastim.
    key_2 = w2 ^ key_1 # yandaki degerlerimi xor'ladim ve key_2 olarak yeni bir 4x1 matrix tanimladim
   
    w3 = ((state_in >> 128)%2**32)#256 bitlik degerimin w3 4x1 matrixine ulastim.
    key_3 = w3 ^ key_2 # yandaki degerlerimi xor'ladim ve key_3 olarak yeni bir 4x1 matrix tanimladim
    
    #After SubWord()
    RotWord1 = s_box_table[key_3>>24]                           #key_3 blok'unun en anlamli bitini(FF000000) s_box dan cektik
    RotWord1 = (RotWord1 << 8) + s_box_table[(key_3>>16)%2**8]  #key_3 blok'unun en anlamli bitini(00FF0000) s_box dan cektik
    RotWord1 = (RotWord1 << 8) + s_box_table[(key_3>>8)%2**8]   #key_3 blok'unun en anlamli bitini(0000FF00) s_box dan cektik
    RotWord1 = (RotWord1 << 8) + s_box_table[key_3%2**8]        #key_3 blok'unun en anlamli bitini(000000FF) s_box dan cektik


    w4 = ((state_in >> 96)%2**32)#256 bitlik degerimin w4 4x1 matrixine ulastim.
    key_4 = w4 ^ RotWord1 # yandaki degerlerimi xor'ladim ve key_4 olarak yeni bir 4x1 matrix tanimladim

    w5 = ((state_in >> 64)%2**32)#256 bitlik degerimin w5 4x1 matrixine ulastim.
    key_5 = w5 ^ key_4 # yandaki degerlerimi xor'ladim ve key_5 olarak yeni bir 4x1 matrix tanimladim

    w6 = ((state_in >> 32)%2**32)#256 bitlik degerimin w6 4x1 matrixine ulastim.
    key_6 = w6 ^ key_5 # yandaki degerlerimi xor'ladim ve key_6 olarak yeni bir 4x1 matrix tanimladim

    w7 = ((state_in)%2**32)#256 bitlik degerimin w7 4x1 matrixine ulastim.
    key_7 = w7 ^ key_6 # yandaki degerlerimi xor'ladim ve key_7 olarak yeni bir 4x1 matrix tanimladim

    out = (key_0 << 224) |(key_1 << 192) |(key_2 << 160) |(key_3 << 128) |(key_4 << 96) | (key_5 << 64) | (key_6 << 32) | key_7 #Son olarak tüm bloklarimi birlestirdim.

    return out

#AES function--------------------------------------------------------------------------------------

def aes(pt,key):
    Start_of_Round = pt
    Round_Key_Value = key
    ###print('pt: ',hex(pt))
    ###print('key: ',hex(key))
    key_round = 0  #Key expansion islemimin islem sayisini sayacak round degerim.
    Round_Key_Number = Key1(key) #Baslangic olarak 256 bitlik Round_Key_Value mun ilk 128 bitini alıp isleme girmesini sagliyorum.

    for i in range(1,15):
        Start_of_Round = xor(Start_of_Round,Round_Key_Number)
        After_SubBytes = SubBytes(Start_of_Round)
        After_ShiftRows = ShiftRows(After_SubBytes)

        if i !=14:
            After_MixColumns = MixColumns(After_ShiftRows)
        if i % 2 != 0: #tek
            Round_Key_Number = Key2(Round_Key_Value)
        elif i % 2 == 0:  #cift   
            Round_Key_Number = Key1(Round_Key_Value)
            key_round += 1
            Round_Key_Value = KeyExpansion(Round_Key_Value,key_round)
            Round_Key_Number = Key1(Round_Key_Value)    
        
        Start_of_Round = After_MixColumns  

        #print("round[",i,"].start :",hex(Start_of_Round))
        #print("round[",i,"].s_box :",hex(After_SubBytes))
        #print("round[",i,"].s_row :",hex(After_ShiftRows))
        #if i !=14:
        #    print("round[",i,"].m_col :",hex(After_MixColumns))
        #print("round[",i,"].k_sch :",hex(Round_Key_Number))
    
    Start_of_Round = After_ShiftRows
    Round_Key_Number = Key1(Round_Key_Value)
    ct = xor(Start_of_Round,Round_Key_Number)
    #######print('ct : ', hex(ct))
    #print("round[",i,"].Output:",hex(Start_of_Round))
    return ct


#TEST --------------------------------------------------------------------------------------
from Crypto.Cipher import AES
from random import randrange
test_count = 10000
success = 0 
fail = 0 
for i in range(0,test_count):

    plain_text = randrange(0,2**128)
    key = randrange(0,2**256
                    )
    cipher = AES.new(key.to_bytes(32, byteorder='big'), AES.MODE_ECB)
    ct_expected = cipher.encrypt(plain_text.to_bytes(16, byteorder='big'))
    ct_expected = int.from_bytes(ct_expected, byteorder='big')
    ct_computed = aes(plain_text,key)

    if(ct_computed != ct_expected):
        print("ERROR !")
        print("plain_text = ", hex(plain_text))
        print("ct_expected = ", hex(ct_expected))
        print("ct_computed = ", hex(ct_computed))
        print("key = ", hex(key))
        fail += 1
    else:
        success +=1

print("Total Succes =", success)
if fail > 0:
    print("Fail Count =", fail)

