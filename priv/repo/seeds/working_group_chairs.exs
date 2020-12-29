chairs = [
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "4a9698ea-6bb2-4331-8846-0248246ab346",
    working_group_id: "64bbc88e-5a8a-4333-b24a-15f7a4e206d2"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "affdba10-18a8-4402-9847-fe1976166dc3",
    working_group_id: "8e3d6a77-1cb9-441b-8003-d0ac086d134c"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "305cf09b-7cc0-4a29-b02c-d47301a762fb",
    working_group_id: "a1ddc0c8-1a9e-485f-965f-3b15edab6eae"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "a3fe00bc-e734-4f84-8e72-92c5fef519e9",
    working_group_id: "73dfc610-b804-4ed7-9f5f-5a2d0a76dccf"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "dc5c56fe-52ab-479f-97ed-4fc10c3a5d35",
    working_group_id: "d0bb4b0e-8f97-4943-bbb8-c1604a3c27ff"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "589b130f-0ae5-410c-b1d1-3fcaf55d0f6f",
    working_group_id: "30ac01f5-98fd-4328-8af7-d71f0a1a573f"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "a62f4db4-54d7-4fa3-aa8d-b141407d7cf1",
    working_group_id: "91b8273b-a140-40ff-bbb2-3c3840844e54"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "6abaa50e-7b7a-4a1f-afcf-c2ad999c97ab",
    working_group_id: "b8e754bd-3b50-4d06-a9d5-ccf5f2da5a52"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "4bb5466e-440e-4424-b692-2e8fc42fb039",
    working_group_id: "374f7386-d478-4810-9265-9efe89dac4ea"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "4a9698ea-6bb2-4331-8846-0248246ab346",
    working_group_id: "61fd9be3-c96d-408d-b263-77c2b125a110"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "4060d400-7b66-4724-ad16-2f813a94c8f7",
    working_group_id: "d03caa1f-7f93-470d-b03b-ff7d5bdf7235"
  },
  %{
    id: Ecto.UUID.generate(),
    volunteer_id: "589b130f-0ae5-410c-b1d1-3fcaf55d0f6f",
    working_group_id: "5dcf7084-49b3-4477-a86b-523d13283497"
  }
]
Erlef.Seeds.insert(Erlef.Groups.WorkingGroupChair, chairs)
