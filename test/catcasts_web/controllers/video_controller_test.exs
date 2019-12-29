defmodule CatcastsWeb.VideoControllerTest do
  use CatcastsWeb.ConnCase

  @create_attrs %{video_id: "https://www.youtube.com/watch?v=wZZ7oFKsKzY"}
  @invalid_attrs %{video_id: ""}

  describe "index" do
    test "lists all videos", %{conn: conn} do
      conn = get(conn, Routes.video_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Videos"
    end
  end

  describe "new video" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.video_path(conn, :new))
      assert html_response(conn, 200) =~ "type=\"submit\">Add video</button>"
    end
  end

  describe "create video" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> assign(:user, user)
        |> post(Routes.video_path(conn, :create), video: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.video_path(conn, :show, id)

      assert html_response(conn, 302) =~
               "<html><body>You are being <a href=\"/videos/#{id}\">redirected</a>.</body></html>"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> assign(:user, user)
        |> post(Routes.video_path(conn, :create), video: @invalid_attrs)

      assert html_response(conn, 200) =~ "type=\"submit\">Add video</button>"
    end
  end

  describe "delete video" do
    test "deletes chosen video", %{conn: conn} do
      video = youtube_video_fixture()

      conn = delete(conn, Routes.video_path(conn, :delete, video))
      assert redirected_to(conn) == Routes.video_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.video_path(conn, :show, video))
      end
    end
  end
end
