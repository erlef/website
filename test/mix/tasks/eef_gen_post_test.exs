defmodule Mix.Tasks.Eef.Gen.PostTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  describe "run/1" do
    test "generates a blog post template" do
      capture_io(fn ->
        test_file = Mix.Tasks.Eef.Gen.Post.run(["blog", "slug"])
        assert File.exists?(test_file)
        File.rm!(test_file)
      end)
    end

    test "does generates a blog post template when missing params" do
      capture_io(fn ->
        assert_raise Mix.Error, "expected eef.gen.post to receive blog slug, got: \"blog\"", fn ->
          Mix.Tasks.Eef.Gen.Post.run(["blog"])
        end

        assert_raise Mix.Error, "expected eef.gen.post to receive blog slug, got: \"\"", fn ->
          Mix.Tasks.Eef.Gen.Post.run([])
        end
      end)
    end
  end
end
