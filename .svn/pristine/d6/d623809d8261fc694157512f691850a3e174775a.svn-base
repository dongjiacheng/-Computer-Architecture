#include "cachesimulator.h"
#include "cacheblock.h"
#include "utils.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.

   */


  const CacheConfig&  figure = _cache->get_config();
  uint32_t index =  extract_index(address,figure);
  auto Set = _cache->get_blocks_in_set(index);
  for(auto block : Set)
  {
    if(block->is_valid()&& block->get_tag() == extract_tag(address,figure))
    {
      _hits++;
      return block;
    }
  }

  return NULL;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
  const CacheConfig&  figure = _cache->get_config();
  uint32_t index =  extract_index(address,figure);
  uint32_t tag =  extract_tag(address,figure);
  auto Set = _cache->get_blocks_in_set(index);
  Cache::Block* leastRecent = NULL;
  for(auto block : Set)
  {
    if(!block->is_valid())
    {
      block->mark_as_valid();
      block->mark_as_clean();
      block->set_tag(tag);
      block->read_data_from_memory(_memory);
      return block;
    }
    if(leastRecent == NULL)
      leastRecent = block;
    else
    {
      if(leastRecent->get_last_used_time() > block->get_last_used_time())
        leastRecent = block;
    }
  }

  if(leastRecent->is_dirty())
  {
    leastRecent->write_data_to_memory(_memory);
  }

      leastRecent->mark_as_valid();
      leastRecent->mark_as_clean();
      leastRecent->set_tag(tag);
      leastRecent->read_data_from_memory(_memory);
      return leastRecent;


  
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
    const CacheConfig&  figure = _cache->get_config();
    Cache::Block* recent = find_block(address);
    if(recent == NULL)
    {
      recent = bring_block_into_cache(address);
    }

    _use_clock++;

    uint32_t temp = _use_clock.get_count();

    recent->set_last_used_time(temp);

    uint32_t offset = extract_block_offset(address,figure);
    uint32_t result = recent->read_word_at_offset(offset);

  return result;
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
       Cache::Block* recent = find_block(address);
       if(recent == NULL)
       {
        if(_policy.is_write_allocate())
          recent = bring_block_into_cache(address);
        else
        {
          _memory->write_word(address,word);
          return;
        }

       }

       _use_clock++;
       uint32_t temp = _use_clock.get_count();

       recent->set_last_used_time(temp);

        const CacheConfig&  figure = _cache->get_config();
        uint32_t offset = extract_block_offset(address,figure);
        recent->write_word_at_offset(word,offset);

        if(_policy.is_write_back())
        {
          recent->mark_as_dirty();
        }
        else
        {
          recent->write_data_to_memory(_memory);
        }

}
