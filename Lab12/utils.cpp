#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t tag =  cache_config.get_num_tag_bits();
  uint32_t move = (uint32_t)32 - tag;
  if(move >= 32)
    return 0;
  return address>>move;
  //return 0;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t tag =  cache_config.get_num_tag_bits();
  uint32_t offset =  cache_config.get_num_block_offset_bits();
  if(tag == 32)
    return 0;
  address =  address<<(tag);
  address =  address>>(tag+offset);

  return address;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t tag =  cache_config.get_num_tag_bits();
  //uint32_t offset =  cache_config.get_num_block_offset_bits();
  if(tag == 32)
    return 0;

  uint32_t index = cache_config.get_num_index_bits();
  address = address<<(tag+index);
  address = address>>(tag+index);
  return address;
}
