CayoPericoZone = {
    zoneEnabled = true,
    PickUpKey = 74, -- https://docs.fivem.net/docs/game-references/controls/ Set Currently to H
    RepAmount = 2, -- Rep given per harvest
    Item = "pickedtobaccoleaves",
    ChanceItem = false,
    JobDifficulty = {
        {
            label = "easy",
            stops = function() return math.random(3, 4) end,
            amount = function() return math.random(5, 10) end,
        },
        {
            label = "medium",
            stops = function() return math.random(5, 8) end,
            amount = function() return math.random(5, 10) end,
        },
        {
            label = "hard",
            stops = function() return math.random(8, 10) end,
            amount = function() return math.random(5, 10) end,
        }
    },
	Minigame = {
        enabled = false, -- Dependancy PS-UI
        MinigameCircles = 2,
        MinigameTime = 10,
    },
    Fields = {
                {
                    WayPoint = vector2(5301.0063476563, -5258.3408203125),
                    Zone = {
                        vector3(5296.9702148438, -5266.244140625, 32.186229705811),
                        vector3(5312.7890625, -5250.8647460938, 32.63268661499),
                        vector3(5278.9936523438, -5217.181640625, 29.063718795776),
                        vector3(5266.2563476563, -5234.6181640625, 26.861337661743)
                    },
                    Points = {
                        firstLine = {
                            vector3(5306.9487304688, -5248.4609375, 32.508312225342),
                            vector3(5280.32421875, -5222.5732421875, 30.28483581543)
                        },
                        ActivePointAmount = 3,
                        Options = {
                            pointsPerLine = 6,
                            linesPerField = 7,
                            lineOffset = -2.5,
                        },

                    }
                },
                {
                    WayPoint = vector2(5326.115234375, -5231.36328125),
                    Zone = {
                        vector3(5321.1298828125, -5242.16796875, 32.606998443604),
                        vector3(5343.2939453125, -5220.5390625, 31.411678314209),
                        vector3(5304.0981445313, -5180.2846679688, 29.691087722778),
                        vector3(5282.787109375, -5207.4462890625, 28.981597900391)
                    },
                    Points = {
                        firstLine = {
                            vector3(5320.5043945313, -5234.7646484375, 32.624229431152),
                            vector3(5288.6762695313, -5204.7587890625, 29.821804046631)
                        },
                        ActivePointAmount = 3,
                        Options = {
                            pointsPerLine = 9,
                            linesPerField = 9,
                            lineOffset = 2.3,
                        },

                    }
                },
                {
                    WayPoint = vector2(5309.6977539063, -5273.7719726563),
                    Zone = {
                        vector3(5304.7, -5317.46, 35.32),
                        vector3(5334.96, -5286.08, 35.35),
                        vector3(5313.84, -5263.99, 32.76),
                        vector3(5287.8, -5292.71, 32.46)
                    },
                    Points = {
                        firstLine = {
                            vector3(5291.076171875, -5293.2944335938, 33.043743133545),
                            vector3(5316.0908203125, -5269.548828125, 33.339408874512)
                        },
                        ActivePointAmount = 3,
                        Options = {
                            pointsPerLine = 10,
                            linesPerField = 5,
                            lineOffset = 5.0,
                        },

                    }
                },
                {
                    WayPoint = vector2(5350.7275390625, -5203.53125),
                    Zone = {
                        vector3(5315.35, -5175.15, 29.36),
                         vector3(5347.53, -5140.2, 23.13),
                        vector3(5387.09, -5170.93, 31.04),
                        vector3(5351.88, -5209.41, 31.16)
                    },
                    Points = {
                        firstLine = {
                            vector3(5353.83, -5205.22, 30.9),
                            vector3(5385.95, -5170.16, 30.82)
                        },
                        ActivePointAmount = 6,
                        Options = {
                            pointsPerLine = 9,
                            linesPerField = 18,
                            lineOffset = -2.5,
                        },

                    }
                },
                {
                    WayPoint = vector2(5340.2729492188, -5247.7514648438),
                    Zone = {
                        vector3(5332.69, -5250.27, 32.7),
                        vector3(5367.41, -5213.64, 31.15),
                        vector3(5416.35, -5252.63, 36.09),
                        vector3(5388.93, -5297.86, 35.74)
                    },
                    Points = {
                        firstLine = {
                            vector3(5389.57, -5291.92, 35.86),
                            vector3(5336.34, -5250.32, 32.6)
                        },
                        ActivePointAmount = 6,
                        Options = {
                            pointsPerLine = 10,
                            linesPerField = 17,
                            lineOffset = 3.0,
                        },

                    }
                },
                {
                    WayPoint = vector2(5330.8618164063, -5313.341796875),
                    Zone = {
                        vector3(5317.44, -5324.27, 36.72),
                        vector3(5345.57, -5297.02, 36.84),
                        vector3(5385.6, -5332.07, 35.53),
                        vector3(5354.57, -5363.84, 41.75)
                    },
                    Points = {
                        firstLine = {
                            vector3(5353.56, -5360.9, 41.23),
                            vector3(5380.72, -5333.66, 37.06)
                        },
                        ActivePointAmount = 7,
                        Options = {
                            pointsPerLine = 6,
                            linesPerField = 21,
                            lineOffset = -2.5,
                        },

                    }
                },
                {
                    WayPoint = vector2(5214.5053710938, -5182.1181640625),
                    Zone = {
                        vector3(5192.7, -5193.36, 10.68),
                        vector3(5195.48, -5161.42, 8.14),
                        vector3(5221.15, -5144.66, 10.21),
                        vector3(5224.95, -5160.39, 11.04),
                        vector3(5221.96, -5186.12, 13.76)
                    },
                    Points = {
                        firstLine = {
                            vector3(5218.09, -5185.39, 13.5),
                            vector3(5219.56, -5148.39, 10.4)
                        },
                        ActivePointAmount = 3,
                        Options = {
                            pointsPerLine = 6,
                            linesPerField = 10,
                            lineOffset = -2.5,
                        },

                    }
                },
            },
        }
