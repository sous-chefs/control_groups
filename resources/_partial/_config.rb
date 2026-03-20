# frozen_string_literal: true

property :mounts, Hash,
         desired_state: false,
         default: lazy { ControlGroups.default_mounts }

property :manage_runtime, [true, false],
         desired_state: false,
         default: true
