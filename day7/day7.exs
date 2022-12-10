defmodule CodeAdvent2022.Day7 do
  alias CodeAdvent2022.Day7.{Terminal, FileSystem}

  def solve1(input) do
    input
    |> String.split(~r/\n/)
    |> Enum.reduce(Terminal.new(), &handle_line/2)
    |> calculate_directory_sizes()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def solve2(input) do
    dir_sizes =
      input
      |> String.split(~r/\n/)
      |> Enum.reduce(Terminal.new(), &handle_line/2)
      |> calculate_directory_sizes()

    total_volume = 70_000_000
    required_volume = 30_000_000
    available_volume = total_volume - Enum.max(dir_sizes)

    dir_sizes
    |> Enum.sort()
    |> Enum.find(fn dir_size ->
      available_volume + dir_size >= required_volume
    end)
  end

  defp handle_line("$ " <> command, term) do
    execute_command(command, term)
  end

  defp handle_line("dir " <> name, term) do
    Terminal.mkdir(term, name)
  end

  defp handle_line(line, term) do
    [size, name] = String.split(line, " ")
    Terminal.touch(term, name, String.to_integer(size))
  end

  defp execute_command("cd " <> dest, term) do
    Terminal.cd(term, dest)
  end

  defp execute_command("ls", term) do
    term
  end

  defp calculate_directory_sizes(term) do
    term.fs
    |> FileSystem.list_tree()
    |> Enum.filter(&FileSystem.directory?/1)
    |> Enum.map(fn dir ->
      dir
      |> FileSystem.list_tree()
      |> Enum.filter(&FileSystem.file?/1)
      |> Enum.map(& &1.size)
      |> Enum.sum()
    end)
  end

  defmodule Terminal do
    alias CodeAdvent2022.Day7.{FileSystem, Directory, File}

    defstruct [:fs, :cwd]

    def new do
      %__MODULE__{
        fs: FileSystem.new(),
        cwd: ["/"]
      }
    end

    def cd(term = %__MODULE__{}, "/") do
      Map.put(term, :cwd, ["/"])
    end

    def cd(term = %__MODULE__{}, "..") do
      Map.put(term, :cwd, tl(term.cwd))
    end

    def cd(term = %__MODULE__{}, name) do
      term
      |> mkdir(name)
      |> Map.put(:cwd, [name | term.cwd])
    end

    def mkdir(term = %__MODULE__{}, name) do
      ensure_entry(term, Directory.new(name))
    end

    def touch(term = %__MODULE__{}, name, size) do
      ensure_entry(term, File.new(name, size))
    end

    defp ensure_entry(term = %__MODULE__{}, entry) do
      Map.put(
        term,
        :fs,
        FileSystem.ensure_entry(term.fs, Enum.reverse(term.cwd), entry)
      )
    end
  end

  defmodule File do
    defstruct [:name, :size]

    def new(name, size) do
      %__MODULE__{
        name: name,
        size: size
      }
    end
  end

  defmodule Directory do
    defstruct [:name, :children]

    def new(name) do
      %__MODULE__{
        name: name,
        children: %{}
      }
    end

    def has_entry?(dir = %__MODULE__{}, name) do
      Map.has_key?(dir.children, name)
    end
  end

  defmodule FileSystem do
    alias CodeAdvent2022.Day7.{Directory, File}

    defstruct [:children]

    def new do
      %__MODULE__{
        children: %{
          "/" => Directory.new("/")
        }
      }
    end

    def find(fs = %__MODULE__{}, path) do
      case Enum.reduce(path, fs, fn name, dir -> dir.children[name] end) do
        nil ->
          raise "#{path} not found"

        entry ->
          entry
      end
    end

    def ensure_entry(fs = %__MODULE__{}, path, entry) do
      if Directory.has_entry?(find(fs, path), entry.name) do
        fs
      else
        create_entry(fs, path, entry)
      end
    end

    def create_entry(fs = %__MODULE__{}, path, entry) do
      update_path = [
        Access.key!(:children)
        | Enum.flat_map(path, &[Access.key!(&1), Access.key!(:children)])
      ]

      update_in(fs, update_path, fn siblings ->
        if Map.has_key?(siblings, entry.name) do
          raise "#{entry.name} already exists"
        else
          Map.put(siblings, entry.name, entry)
        end
      end)
    end

    def list_tree(fs = %__MODULE__{}) do
      Enum.flat_map(Map.values(fs.children), &list_tree/1)
    end

    def list_tree(d = %Directory{}) do
      do_list_tree(Map.values(d.children), [d])
    end

    defp do_list_tree([], acc), do: acc
    defp do_list_tree([f = %File{} | es], acc), do: do_list_tree(es, [f | acc])

    defp do_list_tree([d = %Directory{} | es], acc) do
      do_list_tree(es, do_list_tree(Map.values(d.children), [d | acc]))
    end

    def directory?(%Directory{}), do: true
    def directory?(_), do: false

    def file?(%File{}), do: true
    def file?(_), do: false
  end
end
