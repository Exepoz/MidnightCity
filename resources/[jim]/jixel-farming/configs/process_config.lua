--[[
-- https://docs.fivem.net/docs/game-references/blips/
--]]

Process = {
    Juicer = {
		Enabled = true,
        BlipSettings = {
            BlipEnabled = true,  Label = "Juicer",
		    BlipSprite = 274, BlipColor = 21,
            BlipLoc = vec4(405.6, 6526.34, 27.7, 86.5),
        },
        Setup = {
            Locations = {
                { coords = vec4(405.6, 6526.34, 27.7, 86.5), h = 86.5, l = 2.6, w = 0.6, minZ = 27.2, maxZ = 28.3,
                prop = "prop_table_03", prop2 = "prop_kitch_juicer", prop2loc = vec4(405.61, 6526.79, 28.5, 86.5)},
            }
        }
    },
    Processor = {
        Enabled = true,
        BlipSettings = {
            BlipEnabled = true,  Label = "Processor",
            BlipSprite = 274, BlipColor = 21,
            BlipLoc = vec4(428.66, 6478.58, 28.8, 318.29),
        },
        Setup = {
            Locations = {
                { coords = vec4(428.87, 6478.52, 28.8, 135.0), h = 315.0, l = 0.6, w = 2.6, minZ = 27.9, maxZ = 29.4,
                prop = "prop_table_03", prop2 = "prop_tea_urn", prop2loc = vec4(428.66, 6478.58, 29.6, 160.0)},
            }
        }
    },
    Pestle = {
        Enabled = true,
        BlipSettings = {
            BlipEnabled = true, Label = "Pestle",
            BlipSprite = 274, BlipColor = 21,
            BlipLoc = vec4(2899.32, 4399.09, 51, 207.61),
        },
        Setup = {
            Locations = {
                { coords = vec4(2554.24, 4668.23, 34.02, 314.9), l = 0.6, w = 0.6, minZ = 30.5, maxZ = 30.5,
                prop = "prop_table_03", prop2 = "v_res_pestle", prop2loc = vec4(2899.32, 4399.09, 51, 207.61)
            },
            }
        }
    },
	MilkProcess = {
        Enabled = true,
        BlipSettings = {
            BlipEnabled = true,  Label = "Milk Process",
		    BlipSprite = 274, BlipColor = 21,
		    BlipLoc = vec4(2554.24, 4668.23, 34.02, 293.57),
        },
        Setup = {
            Locations = {
                { coords = vec4(2554.24, 4668.23, 34.02, 110.0), h = 110.0, l = 2.5, w = 2.5, minZ = 33.5, maxZ = 34.5,
                prop = "prop_cementmixer_01a"
                },
            },
        },
        MilkBucketSetup = {
            MilkBucket = true, -- If Bucket is needed to collect Milk
            MultiBucket = true, -- Option to turn on grabbing Multiple Buckets instead of 1:1
            MultibucketOptions = {1, 5, 10},
                BucketLocations = {
                    { coords = vec4(2297.26, 4908.87, 41.37, 230.59),
                    h = 314.9, l = 0.6, w = 0.6, minZ = 30.5, maxZ = 30.5,
                    prop = "prop_buckets_02"},
                },
        },
    },
	ChickenProcess = {
        Enabled = true,
        BlipSettings = {
            BlipEnabled = false,  Label = "Chicken Process",
            BlipSprite = 274, BlipColor = 5,
            BlipLoc = vec4(-95.1, 6207.73, 32.28, 134.26),
        },
        Setup = {
            Locations = {
                    SlaughterLoc ={
                        {
                            coords = vec3(-89.43, 6234.71, 31.09), h = 302, l = 0.6, w = 2.6, minZ = 30.5, maxZ = 32.5,
                            helpmarker = {
                                { coords = vector3(-88.04, 6235.47, 30.3), bobbing = true, color = "cyan", scalex = 1.0, scaley = 1.0, scalez = 1.0 }
                            }
                        }
                    },
                    PrepLoc = {
                        {
                            coords = vec3(-86.07, 6229.73, 31.09), h = 35, l = 2.2, w = 2.2, minZ = 30.5, maxZ = 32.5,
                            helpmarker = {
                                { coords = vector3(-87.46, 6228.85, 30.3), bobbing = true, color = "cyan", scalex = 1.0, scaley = 1.0, scalez = 1.0 },
                                { coords = vector3(-84.98, 6230.77, 30.3), bobbing = true, color = "cyan", scalex = 1.0, scaley = 1.0, scalez = 1.0 }
                            }
                        }
                    },
                    ProcessLoc = {
                        {
                            coords = vec4(-95.24, 6207.52, 30.5, 314.9),  h = 315, l = 0.7, w = 1.4, minZ = 30.5, maxZ = 31.5,
                            helpmarker = {
                                { coords = vector3(-95.97, 6207.24, 30.03), color = "purple", scalex =  1.0, scaley =  1.0, scalez =  1.0,},
                            },
                        },
                        {
                            coords = vec4(-99.3, 6205.55, 30.5, 314.9), h = 225.00, l = 0.8, w = 1.3, minZ = 30.5, maxZ = 31.5,
                            helpmarker =  {
                                { coords = vector3(-99.76, 6206.2, 30.03),  color = "purple", scalex =  1.0, scaley =  1.0, scalez =  1.0,},
                            },
                        },
                    },
                },
            },
        },
        MeatProcess = {
            BlipSettings = {
                    BlipEnabled = true,  Label = "Meat Process",
                    BlipSprite = 274, BlipColor = 6,
                    BlipLoc = vec4(984.11, -2113.96, 30.76, 353),
            },
            Setup = {
                Locations = {
                        ProcessLoc = {
                                {
                                    coords = vec4(984.02, -2113.63, 30.48, 353.0), h = 353.0, l = 1.8, w = 1.8, minZ = 29.76, maxZ = 31.76,
                                    helpmarker = {
                                        { coords = vector3(985.66, -2117.49, 30.25), color = "purple", scalex =  1.0, scaley =  1.0, scalez =  1.0, }
                                    },
                                },
                                {
                                    coords = vec4(984.74, -2117.68, 30.76, 353.0), h = 135.85, l = 1.5, w = 1.5, minZ = 29.76, maxZ = 31.76, prop = "v_ind_coo_half",
                                    helpmarker = {
                                        { coords = vector3(984.51, -2112.62, 30.25), color = "purple", scalex =  1.0, scaley =  1.0, scalez =  1.0,}
                                    },
                                }
                            },
                        SlaughterLocHelper = {{
                            helpmarker = {
                                { coords = vector3(990.92, -2183.84, 29.8), color = "purple", scalex =  1.0, scaley =  1.0, scalez =  1.0,}
                                    },

                            },
                        }
                    }
                }
            },
            Targets = {
                BlipSettings = {
                    BlipEnabled = false,  Label = "Drying & Curing",
                    BlipSprite = 274, BlipColor = 6,
                    BlipLoc = vector4(4922.87, -5283.89, 5.76, 89.1),

            },
                Drying = {
                    { coords = vec4(4930.53, -5293.55, 5.57, 270.0), h = 270.0,l = 1.0, w = 1.0, minZ = 0.0, maxZ = 6.0, 
                    prop = "prop_table_03", prop2 = "prop_tea_urn", prop2loc = vec4(428.66, 6478.58, 29.6, 160.0)},
                },
                Curing = {
                   { coords = vector4(4929.94, -5289.69, 5.72, 270.0), h =  270.0, l = 1.0, w =1.0, minZ = 0.0, maxZ = 6.0, 
                   prop = "prop_table_03", prop2 = "prop_tea_urn", prop2loc = vec4(428.66, 6478.58, 29.6, 160.0)},
                },
                CigarBarDrying = {
                   { coords = vector4(4928.53, -5289.82, 5.75, 0.0), h =  0.0, l = 1.0, w =1.0, minZ = 0.0, maxZ = 6.0, },
                },
                CigarBarCuring = {
                   { coords = vector4(4922.14, -5283.85, 5.76, 0.0), h =  0.0, l = 1.0, w =1.0, minZ = 0.0, maxZ = 6.0, },
                },
           }
        }



