defmodule Mix.Tasks.Add do
  use Mix.Task

  @shortdoc "Adds a package from Hex.pm to mix.exs"

  def run(args) do
    Mix.Task.run("app.start")

    case args do
      [package_name] ->
        case add_package(package_name) do
          :ok -> run_mix_deps_get()
          :error -> :ok
        end

      [package_name, version] ->
        if add_dependency_to_mix_exs(package_name, version) do
          run_mix_deps_get()
        else
          Mix.shell().error("Failed to add #{package_name} #{version} to mix.exs dependencies.")
        end

      _ ->
        Mix.shell().error("Usage: mix add <package_name> [version]")
    end
  end

  defp add_package(package_name) do
    case get_latest_version(package_name) do
      {:ok, version} ->
        if add_dependency_to_mix_exs(package_name, version) do
          Mix.shell().info("Added #{package_name} #{version} to mix.exs dependencies.")
          :ok
        else
          Mix.shell().error("Failed to add #{package_name} #{version} to mix.exs dependencies.")
          :error
        end

      {:error, reason} ->
        Mix.shell().error("Failed to add #{package_name}: #{reason}")
        :error
    end
  end

  defp get_latest_version(package_name) do
    case System.cmd("mix", ["hex.info", package_name]) do
      {output, 0} ->
        case parse_version(output) do
          nil -> {:error, "Unable to parse version"}
          version -> {:ok, version}
        end

      {_, _} ->
        {:error, "Package not found on Hex.pm"}
    end
  end

  defp parse_version(output) do
    case Regex.run(~r/Versions\s+:\s+([^\s,]+)/, output) do
      [_, version] -> version
      _ -> nil
    end
  end

  defp add_dependency_to_mix_exs(package_name, version) do
    mix_file = "mix.exs"
    contents = File.read!(mix_file)
    new_dep = "{:#{package_name}, \"~> #{version}\"}"

    new_contents =
      contents
      |> String.replace(~r/deps do\s*\[/, "deps do\n    [#{new_dep},")

    case File.write(mix_file, new_contents) do
      :ok -> true
      _ -> false
    end
  end

  defp run_mix_deps_get do
    {_, exit_code} = System.cmd("mix", ["deps.get"])
    if exit_code == 0 do
      Mix.shell().info("Successfully fetched dependencies.")
    else
      Mix.shell().error("Failed to fetch dependencies.")
    end
  end
end
