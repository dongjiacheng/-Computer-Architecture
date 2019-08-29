#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
	auto Blocks = _cache[index];
	for(auto block : Blocks)
		{
		if(block.valid())
		{
			if(block.tag() == tag)
				return block.get_byte(block_offset);	
			
		}		

		}
	

return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
      auto Blocks = &_cache[index];
      for(auto& block : *Blocks) 
		{
			if(block.valid() == false)
			{
			block.replace(tag, data);
			return;
			}	
		}
	_cache[index][0].replace(tag,data);
 	
}
