defmodule GenReport do

  alias GenReport.Parser

  @available_names [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  @available_months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
     "outubro",
     "novembro",
     "dezembro"
  ]

  def build(), do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
      filename
      |> Parser.parse_file()
      |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)

  end

  defp sum_values([name, total_hours, _day, month, year], %{
         "all_hours" => all_hours,
         "hours_per_month" => hours_per_month,
         "hours_per_year" => hours_per_year
       }) do
    new_name = String.downcase(name)
    all_hours = calculate_all_hours(all_hours, new_name, total_hours)
    hours_per_month = calculate_hours_per_month(hours_per_month, new_name, total_hours, month)
    hours_per_year = calculate_hours_per_year(hours_per_year, new_name, total_hours, year)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp calculate_all_hours(all_hours, name, total_hours) do
    Map.put(all_hours, name, all_hours[name] + total_hours)
  end

  defp calculate_hours_per_month(hours_per_month, name, total_hours, month) do
    calc_hours_month =
      hours_per_month
      |> Map.get(name)
      |> Map.update(month, 0, fn curr -> curr + total_hours end)

    %{hours_per_month | name => calc_hours_month}
  end

  defp calculate_hours_per_year(hours_per_year, name, total_hours, year) do
    calc_hours_year =
      hours_per_year
      |> Map.get(name)
      |> Map.update(year, 0, fn curr -> curr + total_hours end)

    %{hours_per_year | name => calc_hours_year}
  end

  defp report_acc do
    build_report(
      report_names_acc(),
      get_names_per_acc(report_months_acc()),
      get_names_per_acc(report_years_acc())
    )
  end

  defp report_names_acc, do: Enum.into(@available_names, %{}, &{&1, 0})

  defp report_months_acc do
    @available_months
    |> Enum.into(%{}, &{&1, 0})
  end

  defp report_years_acc, do: Enum.into(2016..2020, %{}, &{&1, 0})

  defp get_names_per_acc(acc) do
    @available_names
    |> Enum.into(%{}, &{&1, acc})
  end

  def build_report(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end
end
