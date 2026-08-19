import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    // Unit tests only. Interoperability suites under tests/ need the pinned
    // fixtures from `make testdata` and get their own runner when they land,
    // so they must not be picked up by the plain unit run.
    include: ['src/**/*.test.ts'],
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      reportsDirectory: 'build/coverage',
      include: ['src/**/*.ts'],
      exclude: ['src/**/*.test.ts', 'src/index.ts'],
    },
    reporters: process.env.CI ? ['default', 'junit'] : ['default'],
    outputFile: { junit: 'build/test/junit.xml' },
  },
});
