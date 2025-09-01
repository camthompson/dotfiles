return {
  "snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        {
          section = "terminal",
          cmd = "pokemon-colorscripts -n gengar --no-title; sleep .1",
          indent = 12,
          height = 20,
        },
        { section = "keys" },
        { section = "startup" },
      },
    },
  },
}
