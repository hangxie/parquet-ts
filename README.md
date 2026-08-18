# parquet-ts

A TypeScript-native implementation of the [Apache Parquet](https://parquet.apache.org/) file format for TypeScript and JavaScript.

> **Status: pre-alpha.** Nothing is implemented yet. See [issue #1](https://github.com/hangxie/parquet-ts/issues/1) for the architecture and milestone roadmap.

## Goals

- Read Parquet files into plain JavaScript objects, with no reflection, decorators, classes, or generated model code.
- Write JavaScript objects to Parquet using an explicit, data-only schema.
- Preserve Parquet types losslessly: `INT64` as `bigint`, `BYTE_ARRAY` as `Uint8Array`, with precision-losing conversions opt-in only.
- Support nested data (`LIST`, `MAP`, optional groups) as a first-class subsystem.
- Stream over random-access I/O rather than loading whole files into memory.
- Interoperate with parquet-go, PyArrow, and DuckDB.

## Requirements

- Node.js 22 or newer.

## Development

    make all       # deps, format, lint, test, build — must pass before every commit
    make test      # unit tests with coverage
    make lint      # Biome check plus tsc --noEmit
    make format    # Biome format
    make build     # compile to dist/
    make help      # list all targets

Contributor expectations live in [AGENTS.md](AGENTS.md).

## License

BSD 3-Clause. See [LICENSE](LICENSE).
