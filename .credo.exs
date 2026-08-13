%{
  configs: [
    %{
      name: "default",
      strict: true,
      files: %{
        included: ["lib/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      checks: [
        {Credo.Check.Readability.MaxLineLength, max_length: 120},
        {Credo.Check.Design.TagTODO, exit_status: 0}
      ]
    }
  ]
}
