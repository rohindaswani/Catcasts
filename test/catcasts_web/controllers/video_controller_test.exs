defmodule CatcastsWeb.VideoControllerTest do
  use CatcastsWeb.ConnCase

  @create_attrs %{duration: "some duration", thumbnail: "some thumbnail", title: "some title", video_id: "some video_id", view_count: 42}
  @update_attrs %{duration: "some updated duration", thumbnail: "some updated thumbnail", title: "some updated title", video_id: "some updated video_id", view_count: 43}
  @invalid_attrs %{duration: nil, thumbnail: nil, title: nil, video_id: nil, view_count: nil}

  describe "index" do
    test "lists all videos", %{conn: conn} do
      conn = get(conn, Routes.video_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Videos"
    end
  end

  describe "new video" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.video_path(conn, :new))
      assert html_response(conn, 200) =~ "New Video"
    end
  end

  describe "create video" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.video_path(conn, :create), video: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.video_path(conn, :show, id)

      conn = get(conn, Routes.video_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Video"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.video_path(conn, :create), video: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Video"
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
