defmodule Provider do
  @moduledoc """
  A module for setting up common Ecto query imports and basic CRUD operations.

  This module provides a macro `__using__/1` to include the necessary imports and basic CRUD operations for working with Ecto queries.
  """

  @doc """
  Sets up common imports and basic CRUD operations for modules using `Provider`.

  This macro imports `Ecto.Query` and defines basic CRUD functions: `get/3`, `insert/2`, `update/2`, and `delete/2`.

  ## Examples

      defmodule MyRepo do
        use Provider
        alias MyApp.Repo

        def get_all_users do
          get(User)
        end

        def create_user(attrs) do
          insert(%User{}, attrs)
        end

        def update_user(user, attrs) do
          update(user, attrs)
        end

        def delete_user(user) do
          delete(user)
        end
      end
  """
  defmacro __using__(_) do
    quote do
      import Ecto.Query

      alias MyApp.Repo

      def get(schema, id) do
        Repo.get(schema, id)
      end

      def get_all(schema) do
        Repo.all(from(s in schema))
      end

      def insert(schema, attrs) do
        changeset = Ecto.Changeset.change(schema, attrs)
        Repo.insert(changeset)
      end

      def update(struct, attrs) do
        changeset = Ecto.Changeset.change(struct, attrs)
        Repo.update(changeset)
      end

      def delete(struct) do
        Repo.delete(struct)
      end
    end
  end
end
