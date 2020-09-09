module.exports = {
  purge: [],
  theme: {
    truncate: {
      lines: {
          2: '2',
          3: '3',
        }
    },
    extend: {
      height: theme => ({
        "screen/2": "50vh",
        "screen/3": "calc(100vh / 3)",
      }),
    },
  },
  variants: {},
  plugins: [
    require('tailwindcss-truncate-multiline')(),
  ],
}
