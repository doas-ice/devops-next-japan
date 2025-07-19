import { dirname } from "path";
import { fileURLToPath } from "url";
import { FlatCompat } from "@eslint/eslintrc";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const compat = new FlatCompat({
  baseDirectory: __dirname,
});

const eslintConfig = [
  ...compat.extends("next/core-web-vitals"),
  {
    rules: {
      // === MINIMAL AGGRESSIVE RULES ===
      
      // ERROR RULES (will fail the pipeline)
      // "no-console": "error",                    // No console.log statements
      // "no-var": "error",                        // No var declarations
      // "prefer-const": "error",                  // Use const instead of let when possible
      // "no-unused-vars": "error",                // No unused variables
      // "eqeqeq": "error",                        // Use === instead of ==
      
      // WARNING RULES (will show warnings but not fail)
      "no-trailing-spaces": "warn",             // No trailing whitespace
      "eol-last": "warn",                       // Files must end with newline
    },
  },
  {
    files: ["**/*.js", "**/*.jsx", "**/*.ts", "**/*.tsx"],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "module",
      globals: {
        console: "readonly",
        process: "readonly",
        Buffer: "readonly",
        __dirname: "readonly",
        __filename: "readonly",
        global: "readonly",
        module: "readonly",
        require: "readonly",
        exports: "readonly",
      },
    },
  },
];

export default eslintConfig;
