defmodule Mix.Tasks.Eef.Gen.EventTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  describe "run/1" do
    test "generates an event template" do
      capture_io(fn ->
        test_file = Mix.Tasks.Eef.Gen.Event.run(["slug"])
        assert File.exists?(test_file)
        File.rm!(test_file)
      end)
    end

    test "does generates a event template when missing params" do
      capture_io(fn ->
        assert_raise Mix.Error, "expected eef.gen.event to receive event slug, got: \"\"", fn ->
          Mix.Tasks.Eef.Gen.Event.run([])
        end
      end)
    end
  end
end
