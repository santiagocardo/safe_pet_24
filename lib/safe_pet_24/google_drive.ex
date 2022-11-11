defmodule SafePet24.GoogleDrive do
  alias GoogleApi.Drive.V3, as: Drive

  def base_url, do: "https://drive.google.com/uc?id="

  @google_drive_scope "https://www.googleapis.com/auth/drive.file"
  def upload_file(filename, path) do
    with {:ok, %{token: token}} <- Goth.Token.for_scope(@google_drive_scope) do
      token
      |> Drive.Connection.new()
      |> Drive.Api.Files.drive_files_create_simple(
        "multipart",
        %Drive.Model.File{name: filename, parents: [drive_parent_id()]},
        path
      )
    end
  end

  def delete_file(file_id) do
    with {:ok, %{token: token}} <- Goth.Token.for_scope(@google_drive_scope) do
      token
      |> Drive.Connection.new()
      |> Drive.Api.Files.drive_files_delete(file_id)
    end
  end

  defp drive_parent_id, do: Application.get_env(:safe_pet_24, :drive_parent_id)
end
