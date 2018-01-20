defmodule ServerStatus.EvercamTest do
  use ServerStatus.DataCase

  alias ServerStatus.Evercam

  describe "users" do
    alias ServerStatus.Evercam.User

    @valid_attrs %{email: "some email", is_employee: true, password: "some password"}
    @update_attrs %{email: "some updated email", is_employee: false, password: "some updated password"}
    @invalid_attrs %{email: nil, is_employee: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Evercam.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Evercam.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Evercam.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Evercam.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_employee == true
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Evercam.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Evercam.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.is_employee == false
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Evercam.update_user(user, @invalid_attrs)
      assert user == Evercam.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Evercam.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Evercam.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Evercam.change_user(user)
    end
  end
end
