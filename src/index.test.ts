import { describe, expect, it } from 'vitest';

import * as api from './index.js';

// Locks the public surface: adding or removing a re-export from src/index.ts is
// an API change, so it has to be an explicit edit here rather than a side effect.
const PUBLIC_API: string[] = [];

describe('package entry point', () => {
  it('exports exactly the documented public surface', () => {
    expect(Object.keys(api).sort()).toStrictEqual([...PUBLIC_API].sort());
  });
});
