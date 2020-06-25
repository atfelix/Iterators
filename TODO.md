# Todo iterators and sequences

- Consider adding some of the string iterators that Rust has as well
- Consider adding lazy exact and inexact sequence for strings to that the iterator products `Substring`s or `String`s instead of `[String.Element]?`
- Consider adding a lazy chunking sequence that handles strings instead of using `LazyChunkingSequence` as it leads to an unfortunate API for strings
- See `LazyChunkingSequenceTests.testChunkInexactSequence` for example
- Make types / extension methods publicly available
- Add documentation each type
