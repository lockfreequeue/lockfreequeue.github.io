# design target
a. In modern systems, spatial locality of memory is more important than minimizing the total number of pages. 
    Data that is allocated together is often used together. 
b. It is also optimized to reduce lock contention when multiple threads try to allocate memory.

# jemalloc 
## strutures
- Arena 
If we imagine a pool of arenas, each thread is given an arena based on the hash of its thread-id or a similar mechanism. 
class Arena {
  List<Thread> threads; // Threads that this arena is associated with
  List<Chunk> chunks; // Chunks that this arena manages  
  Lock lock; // guard accesses to various things in this arena.
  RBTree<Run> runsAvailClean; // let's talk about runs in a little bit.
  // clean vs dirty = free zeroed data (calloc) vs free dirty data (malloc).
  RBTree<Run> runsAvailDirty;
  List<Bin> bins; // we will look at Bins soon.
}

- Chunks
They are typically of the same size — 2MB. Each chunk is associated with an Arena. Chunks are the highest abstraction used in jemalloc’s design, the rest of the structures described below are actually placed within a chunk somewhere.


class Chunk {
  Arena arena; // Arena that this chunk is associated with
  boolean dirtied; // this is set if the chunk has ever been dirtied
  List<Run> runs;
  // metadata about free pages for a region size
  RBTreeMultimap<RegionSize, Page> freePages;
}

- Regions
A region is jemalloc term for the size of the allocation a user requests. Regions are divided into three classes according to their size, namely:
    small/medium: these regions are smaller than the page size (typically 4KB)
    large: these regions are between small/medium and huge.
    huge: size of these is greater than the chunk size. These are dealt with separately and not managed by arenas, they have a global allocator tree.
enum RegionSize {
  SM_2(2),
  SM_4(4),
  SM_8(8),
  SM_20(20),
  SM_40(40),
  .
  .
  .
  LARGE_2MB(2 * 1024 * 1024);
  
  int allocationSize;
}

- Run
a chunk is broken into several runs. Each run is actually a set of one or more contiguous pages
class Run {
  Bin bin; // bins are further down in our discussion
  RegionSize regionSize; // the region size for this run.
  List<Page> pages; // pages that are a part of this run. 
  int numFreeRegions;
  int totalNumRegions = pages.size() / regionSize;
  boolean freeRegions[totalNumRegions]; // initially all set to true
  // more metadata to quickly identify the first available region
}

- Bin

A bin is what keeps track of free regions of a specific size. 
All the runs in a Bin have the same region size, equal to the binRegionSize. 
Every Run is part of some Bin. A Bin can manage multiple Runs.

class Bin {
  RegionSize binRegionSize;
  List<Run> runs;
  Run currentRun; // current run of this bin
}

ref https://medium.com/iskakaushik/eli5-jemalloc-e9bd412abd70
