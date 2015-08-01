#ifndef HDELIGHT_PROOFS_COMMON_H
#define HDELIGHT_PROOFS_COMMON_H

#include <assert.h>
#include <inttypes.h>

#define BITS(T)  (sizeof(T) * 8)

#define assume(x) __CPROVER_assume((x))

int nondet_int();
unsigned nondet_unsigned();

uint8_t nondet_u8();
uint16_t nondet_u16();
uint32_t nondet_u32();
uint64_t nondet_u64();

int8_t nondet_s8();
int16_t nondet_s16();
int32_t nondet_s32();
int64_t nondet_s64();

inline int proof_popcnt(uint64_t u)
{
    int r = 0;
    for(int i=0; i<64; i++)
        if(u & (1ull << i)) r ++;
    return r;
}

template<class T>
T nondet() { return T(nondet_u64()); }

#endif
