NightBonus = 1.5
KloudDev.Locations = {
    ["burgershot"] = {
        max_stocks = 20,
        bag_model = `prop_food_bs_bag_01`,
        cooldown = 300, -- in secs
        blip = {
            enabled = false,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Burgershot",
            sprite = 536,
            scale = 0.9,
            colour = 1,
        },
        delivery = {
            item = "delivery_food",
            money_type = "cash",
            deposit = {
                enabled = true,
                amount = 200
            },
            reward = {
                enabled = true,
                min = 300,
                max = 350
                -- Real reward = `this - deposit.amount`
            }
        },
        restock = {
            job = true,
            item = "delivery_burgershot",
            reward = {
                enabled = true,
                type = "cash", -- not used, sent to job's account (still the money amount below)
                min = 100,
                max = 200
                -- Players receive pay tickets
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(-1198.74, -891.4, 12.89, 344.91),
                ped = {
                    enabled = true,
                    model = "csb_burgerdrug",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
            stock_zone = {
                type = "target",
                job = {
                    required = true,
                    job_name = "burgershot",
                },
                coords = vec4(-1198.81, -893.19, 12.89, 167.87),
                ped = {
                    enabled = true,
                    model = "csb_burgerdrug",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
        },
    },
    ["catcafe"] = {
        max_stocks = 20,
        bag_model = `prop_food_bag1`,
        cooldown = 300, -- in secs
        blip = {
            enabled = false,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Burgershot",
            sprite = 536,
            scale = 0.9,
            colour = 1,
        },
        delivery = {
            item = "delivery_food",
            money_type = "cash",
            deposit = {
                enabled = true,
                amount = 200
            },
            reward = {
                enabled = true,
                min = 300,
                max = 350
                -- Real reward = `this - deposit.amount`
            }
        },
        restock = {
            job = true,
            item = "delivery_catcafe",
            reward = {
                enabled = true,
                type = "cash", -- not used, sent to job's account (still the money amount below)
                min = 100,
                max = 200
                -- Players receive pay tickets
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(-581.24, -1058.55, 21.34, 224.25),
                ped = {
                    enabled = true,
                    model = "a_f_y_business_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
            stock_zone = {
                type = "target",
                job = {
                    required = true,
                    job_name = "catcafe",
                },
                coords = vec4(-588.06, -1054.98, 21.34, 139.56),
                ped = {
                    enabled = true,
                    model = "a_f_y_business_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
        },
    },
    ["beanmachine"] = {
        max_stocks = 20,
        bag_model = `prop_food_bag1`,
        cooldown = 300, -- in secs
        blip = {
            enabled = false,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Bean Machine",
            sprite = 536,
            scale = 0.9,
            colour = 1,
        },
        delivery = {
            item = "delivery_food",
            money_type = "cash",
            deposit = {
                enabled = true,
                amount = 200
            },
            reward = {
                enabled = true,
                min = 300,
                max = 350
                -- Real reward = `this - deposit.amount`
            }
        },
        restock = {
            job = true,
            item = "delivery_beanmachine",
            reward = {
                enabled = true,
                type = "cash", -- not used, sent to job's account (still the money amount below)
                min = 100,
                max = 200
                -- Players receive pay tickets
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(115.16, -1041.50, 28.28, 264.02),
                ped = {
                    enabled = true,
                    model = "a_m_m_bevhills_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
            stock_zone = {
                type = "target",
                job = {
                    required = true,
                    job_name = "beanmachine",
                },
                coords = vec4(122.77, -1043.97, 28.28, 35.49),
                ped = {
                    enabled = true,
                    model = "a_m_m_bevhills_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
        },
    },
    ["cluckinbell"] = {
        max_stocks = 20,
        bag_model = `prop_food_cb_bag_01`,
        cooldown = 300, -- in secs
        blip = {
            enabled = false,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Burgershot",
            sprite = 536,
            scale = 0.9,
            colour = 1,
        },
        delivery = {
            item = "delivery_food",
            money_type = "cash",
            deposit = {
                enabled = true,
                amount = 200
            },
            reward = {
                enabled = true,
                min = 300,
                max = 350
                -- Real reward = `this - deposit.amount`
            }
        },
        restock = {
            job = true,
            item = "delivery_cluckinbell",
            reward = {
                enabled = true,
                type = "cash", -- not used, sent to job's account (still the money amount below)
                min = 100,
                max = 200
                -- Players receive pay tickets
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(-157.69, -260.38, 42.60, 303.77),
                ped = {
                    enabled = true,
                    model = "u_m_o_finguru_01",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
            stock_zone = {
                type = "target",
                job = {
                    required = true,
                    job_name = "catcafe",
                },
                coords = vec4(-156.03, -268.70, 42.60, 270.17),
                ped = {
                    enabled = true,
                    model = "u_m_o_finguru_01",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
        },
    },
    ["pospdiner"] = {
        max_stocks = 20,
        bag_model = `prop_food_bag1`,
        cooldown = 300, -- in secs
        blip = {
            enabled = false,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Burgershot",
            sprite = 536,
            scale = 0.9,
            colour = 1,
        },
        delivery = {
            item = "delivery_food",
            money_type = "cash",
            deposit = {
                enabled = true,
                amount = 200
            },
            reward = {
                enabled = true,
                min = 300,
                max = 350
                -- Real reward = `this - deposit.amount`
            }
        },
        restock = {
            job = true,
            item = "delivery_rexdiner",
            reward = {
                enabled = true,
                type = "cash", -- not used, sent to job's account (still the money amount below)
                min = 100,
                max = 200
                -- Players receive pay tickets
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(2547.10, 2578.93, 37.50, 324.50),
                ped = {
                    enabled = true,
                    model = "a_m_m_bevhills_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
            stock_zone = {
                type = "target",
                job = {
                    required = true,
                    job_name = "catcafe",
                },
                coords = vec4(2531.34, 2579.95, 37.50, 311.95),
                ped = {
                    enabled = true,
                    model = "a_m_m_bevhills_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
        },
    },
    ["fence"] = {
        max_stocks = nil,
        bag_model = `w_am_case`,
        cooldown = 300, -- in secs
        blip = {
            enabled = false,
            coords  = vec3(-1197.93, -890.53, 13.89),
            label = "Burgershot",
            sprite = 536,
            scale = 0.9,
            colour = 1,
        },
        delivery = {
            item = "delivery_box",
            money_type = "crumbs",
            deposit = {
                enabled = true,
                amount = 100
            },
            reward = {
                enabled = true,
                min = 150,
                max = 175
                -- Real reward = `this - deposit.amount`
            }
        },
        restock = {
            job = nil,
            item = nil,
            reward = {
                enabled = true,
                type = "cash", -- not used, sent to job's account (still the money amount below)
                min = 100,
                max = 200
                -- Players receive pay tickets
            }
        },
        positions = {
            start_delivery = {
                type = "target",
                job = {
                    required = false,
                    job_name = nil,
                },
                coords = vec4(-274.68, -2211.19, 10.05, 90.21),
                ped = {
                    enabled = false,
                    model = "a_m_m_bevhills_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
            stock_zone = {
                type = "target",
                job = {
                    required = true,
                    job_name = "catcafe",
                },
                coords = nil,
                ped = {
                    enabled = false,
                    model = "a_m_m_bevhills_02",
                    animation = {
                        dict = nil,
                        clip = nil,
                    }
                }
            },
        },
    },
}