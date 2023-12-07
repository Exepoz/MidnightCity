function formatAmount(amount, addSuffix) {
  let suffix = '';
  if (addSuffix) {
    if (amount >= 1000000) {
      amount /= 1000000;
      suffix = 'M';
    } else if (amount >= 1000) {
      amount /= 1000;
      suffix = 'K';
    }
  }

  const formatter = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: addSuffix ? 0 : 2,
    maximumFractionDigits: addSuffix ? 1 : 2,
  });

  return formatter.format(amount) + suffix;
}

// defaultColors: {
//   health: "#FF3737",
//   armor: "#379FFF",
//   stress: "#FF37D3",
//   hunger: "#FFD337",
//   water: "#00FFF0",
//   oxygen: "#37FF63",
//   cash: "#83FF37",
//   bank: "#83FF37",
//   black: "#83FF37",
//   job: "#379FFF",
//   weapon: "#FF7337",
//   clock: "#379FFF",
//   id: "#FFFFFF",
//   bars: "#9643FF",
// },

const app = new Vue({
  el: '#app',
  data() {
    return {
      backgroundImageStyle: {
        backgroundImage: "url('assets/img/background.svg')"
      },
      defaultColors: {
        health: "#FFFFFF",
        armor: "#FFFFFF",
        stress: "#FFFFFF",
        hunger: "#FFFFFF",
        water: "#FFFFFF",
        oxygen: "#FFFFFF",
        cash: "#FFFFFF",
        bank: "#FFFFFF",
        black: "#FFFFFF",
        job: "#FFFFFF",
        weapon: "#FFFFFF",
        clock: "#FFFFFF",
        id: "#FFFFFF",
        bars: "#FFFFFF",
      },
      colors: ['#3757FF', '#3757FF', '#3757FF', '#3757FF'],
      vehiclerpm:0,
      allHud:false,
      bars: Array(32).fill(0),
      hudMenu:false,
      hudType: localStorage.getItem('hudType') || 'rounded', // squared or rounded
      speedStyle:"squared",
      carHud:false,
      speedHz:'KM/H',
      notifications:[],
      question:[],
      speedometer: {
        speedh:0, fuel:0, noss:0, rpm:0, max:300, maxrpm:7000, gear:0,
        seatbelt: "gray", door: "gray", speed: "gray", engine: "gray", signal: "gray", kmh: "gray", light: "gray"
      },
      player:{
        job:{
          variable:false,
          name:"Policeman",
          grade:"officer"
        },
        weapon:{
          variable:false,
          img:"appistol",
          name:"Shotgun MK2",
          ammo:"133/285"
        },
        clock:{
          variable:false,
          name:"13:42 30.03"
        },
        id:{
          variable:false,
          name:"981 1000"
        },
        microphone:{
          variable:false,
          color:"#FFFFFF"
        },
        cash:{
          variable:false,
          amount: formatAmount(69000, false),
        },
        bank:{
          variable:false,
          amount: formatAmount(6900, true),
        },
        black:{
          variable:false,
          amount: formatAmount(6, false),
        }
      },


      hud: {
        health: {
          percentage: 50,
          color: localStorage.getItem('healthColor') || "#FFFFFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("healthPositionTop") || "11rem",
            left: localStorage.getItem("healthPositionLeft") || "0.75rem",
          },
        },
        armor: {
          percentage: 40,
          color: localStorage.getItem('armorColor') || "#FFFFFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("armorPositionTop") || "11rem",
            left: localStorage.getItem("armorPositionLeft") || "0.75rem",
          },
        },
        stress: {
          percentage: 0,
          color: localStorage.getItem('stressColor') || "#FFFFFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("stressPositionTop") || "11rem",
            left: localStorage.getItem("stressPositionLeft") || "0.75rem",
          },
        },
        hunger: {
          percentage: 40,
          color: localStorage.getItem('hungerColor') || "#FFFFFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("hungerPositionTop") || "11rem",
            left: localStorage.getItem("hungerPositionLeft") || "0.75rem",
          },
        },
        water: {
          percentage: 100,
          color: localStorage.getItem('waterColor') || "#FFFFFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("waterPositionTop") || "11rem",
            left: localStorage.getItem("waterPositionLeft") || "0.75rem",
          },
        },
        oxygen: {
          percentage: 100,
          color: localStorage.getItem('oxygenColor') || "#FFFFFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("oxygenPositionTop") || "11rem",
            left: localStorage.getItem("oxygenPositionLeft") || "0.75rem",
          },
        },
        cash: {
          color: localStorage.getItem('cashColor') || "#83FF37",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("cashPositionTop") || "8.25rem",
            left: localStorage.getItem("cashPositionLeft") || "108.2969rem",
          },
        },
        bank: {
          color: localStorage.getItem('bankColor') || "#83FF37",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("bankPositionTop") || "11.5625rem",
            left: localStorage.getItem("bankPositionLeft") || "109.8906rem",
          },
        },
        black: {
          color: localStorage.getItem('blackColor') || "#83FF37",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("blackPositionTop") || "14.875rem",
            left: localStorage.getItem("blackPositionLeft") || "111.4844rem",
          },
        },
        job: {
          color: localStorage.getItem('jobColor') || "#379FFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("jobPositionTop") || "18.25rem",
            left: localStorage.getItem("jobPositionLeft") || "104.7rem",
          },
        },
        weapon: {
          color: localStorage.getItem('weaponColor') || "#FF7337",
          picker: false,
          drag: false,
        },
        clock: {
          color: localStorage.getItem('clockColor') || "#379FFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("clockPositionTop") || "8.25rem",
            left: localStorage.getItem("clockPositionLeft") || "108.2969rem",
          },
        },
        id: {
          color: localStorage.getItem('idColor') || "#FFFFFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("idPositionTop") || "1.0rem",
            left: localStorage.getItem("idPositionLeft") || "115.0rem",
          },
        },
        microphone: {
          color: localStorage.getItem('micColor') || "#379FFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("microphonePositionTop") || "1.0rem",
            left: localStorage.getItem("microphonePositionLeft") || "112.0rem",
          },
        },
        bars:{
          color: localStorage.getItem('barColor') || "#FFFFFF",
          picker: false,
          drag: false,
        },
        map:{
          color: localStorage.getItem('mapColor') || "#FFFFFF",
          picker: false,
          drag: false,
          type: localStorage.getItem('hud.map.type') || "rounded"
        },
        weapon: {
          color: localStorage.getItem('weaponColor') || "#379FFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("weaponPositionTop") || "27rem",
            left: localStorage.getItem("weaponPositionLeft") || "104.4375rem",
          },
        },
        weapon: {
          color: localStorage.getItem('weaponColor') || "#379FFF",
          picker: false,
          drag: false,
          position: {
            top: localStorage.getItem("weaponPositionTop") || "27rem",
            left: localStorage.getItem("weaponPositionLeft") || "104.4375rem",
          },
        },
      }
    };
  },

  computed: {
    currentDateTime() {
      const now = new Date();
      const year = now.getFullYear();
      const month = String(now.getMonth() + 1).padStart(2, '0');
      const day = String(now.getDate()).padStart(2, '0');
      const hours = String(now.getHours()).padStart(2, '0');
      const minutes = String(now.getMinutes()).padStart(2, '0');
      const seconds = String(now.getSeconds()).padStart(2, '0');
      return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    },
    borderDashArray() {
      const maxPathLength = 500;
      const pathLength = (this.speedometer.speedh * maxPathLength) / 300;
      return `${pathLength} ${500 - pathLength}`;
    },
    speedBarTransform() {
      const clampedSpeedValue = Math.min(this.speedometer.speedh, 300);
      const { innerWidth: width, innerHeight: height } = window;
      const isLargeScreen = width === 2560 && height === 1440;
      const isMiniScreen = width === 1366 && height === 768;

      const angleOffset = (clampedSpeedValue * 310) / 400;
      let rotationAngle;

      if (isLargeScreen) {
        const largeScreenSpeedAngleMap = [
          [301, 300], [250, -85], [230, -70], [210, -75], [190, -80], [175, -85],
          [165, -90], [150, -95], [145, -100], [135, -105], [120, -110], [115, -113],
          [110, -115], [100, -120], [90, -125], [70, -130], [50, -135], [10, -142],
          [0, -140]
        ];

        for (const [speed, angle] of largeScreenSpeedAngleMap) {
          if (clampedSpeedValue >= speed) {
            rotationAngle = angle + angleOffset;
            break;
          }
        }

      }else if (isMiniScreen){
        const largeScreenSpeedAngleMapMini = [
          [301, 300], [250, -85], [230, -70], [210, -75], [190, -80], [175, -85],
          [165, -90], [150, -95], [145, -100], [135, -105], [120, -110], [115, -113],
          [110, -115], [100, -110], [90, -110], [70, -120], [50, -125], [10, -130],
          [0, -130]
        ];

        for (const [speed, angle] of largeScreenSpeedAngleMapMini) {
          if (clampedSpeedValue >= speed) {
            // console.log(angle, angleOffset)
            rotationAngle = angle + angleOffset;
            break;
          }
        }
      }

      else {
        const regularScreenSpeedAngleMap = [
          [250, -85], [235, -80], [185, -85], [165, -90], [140, -100],
          [130, -105], [120, -110], [100, -115], [90, -120], [70, -125],
          [50, -130], [10, -135], [0, -140]
        ];

        for (const [speed, angle] of regularScreenSpeedAngleMap) {
          if (clampedSpeedValue >= speed) {
            rotationAngle = angle + angleOffset;
            break;
          }
        }
      }



      const centerX = 4;
      const centerY = 24;


      this.$nextTick(() => {
        const speedBar = this.$refs.speedBar;
        const speedValue = this.$refs.speedValue;
        if (this.speedometer.speedh > 0) {
          speedBar.classList.add('animation-bar');
        } else {
          speedBar.classList.remove('animation-bar');
          speedValue.classList.remove('animation-text');
        }

        if (this.speedometer.speedh > 50 || this.speedometer.speedh > 100) {
          speedValue.classList.add('animation-text');
        } else {
          speedValue.classList.remove('animation-text');
        }
      });


      return `translate(${centerX}, ${centerY}) rotate(${rotationAngle}) translate(-${centerX}, -${centerY})`;
    },



  },


  watch: {
    "speedometer.speedh": function (newVal, oldVal) {
      const rpmChange = newVal - oldVal;
      if (newVal > 220) {
        setTimeout(() => {
        this.speedometer.rpm = Math.min(this.speedometer.rpm + rpmChange, 85);
      }, 50);
      } else {
        if (rpmChange < 0) {
          this.speedometer.rpm = Math.max(this.speedometer.rpm + rpmChange, 0);
        } else {
          this.speedometer.rpm = this.speedometer.rpm;
        }
      }
    },
    hudType(value) {
      localStorage.setItem('hudType', value);
    }
  },



  created() {
    Object.keys(this.hud).forEach(key => {
      this.$watch(`hud.${key}.color`, function(newColor) {
        localStorage.setItem(`${key}Color`, newColor);
      });
    });
    const hudItems = ['health', 'armor', 'stress', 'hunger', 'water', 'oxygen', 'cash', 'bank', 'black', 'job', 'weapon', 'clock', 'id', 'bars', 'map'];
    hudItems.forEach(item => {
      const colorKey = `${item}Color`;
      this.hud[item].color = localStorage.getItem(colorKey) || this.hud[item].color;
    });


      this.$watch('hud.map.type', function(newType) {
        localStorage.setItem('hud.map.type', newType);
      });


      const savedType = localStorage.getItem('hud.map.type') || 'rounded';
      this.hud.map.type = savedType;
      $.post(`https://${GetParentResourceName()}/GetMap`, JSON.stringify({map:this.hud.map.type}), function(data){})
  },





   methods: {
    typeMap(type){
      this.hud.map.type = type;
      localStorage.setItem('hud.map.type', type);
      const targetElement = this.$refs.targetElement;
      anime({
        targets: targetElement,
        translateX: ['-100%', 0],
        duration: 1000,
        easing: 'easeOutBounce'
      });
      $.post(`https://${GetParentResourceName()}/GetMap`, JSON.stringify({map:this.hud.map.type}), function(data){})
    },
    ResetColor(){
      let data = {
        type: "succes",
        header: "Colors",
        description:"All color settings have been restored."
      }
      this.addNotification(data)
      const hudItems = ['health', 'armor', 'stress', 'hunger', 'water', 'oxygen', 'cash', 'bank', 'black', 'job', 'weapon', 'clock', 'id', 'bars', 'bank'];
      hudItems.forEach(item => {
        this.hud[item].color = this.defaultColors[item];
      });
    },
    addNotification(notification) {
      this.notifications.push(notification);
      setTimeout(() => {
        this.removeNotification(notification);
      }, 10000);
    },
    removeNotification(notification) {
      this.notifications = this.notifications.filter(n => n !== notification);
    },
    setDefaultPositions() {
      const positions = [
        { top: "31.5rem", left: "0.75rem" },
        { top: "35rem", left: "0.75rem" },
        { top: "35rem", left: "0.75rem" },
        { top: "38.5rem", left: "0.75rem" },
        { top: "42.0rem", left: "0.75rem" },
        { top: "45.5rem", left: "0.75rem" },

        { top: "11.5625rem", left: "109.8906rem" },
        { top: "1.0rem", left: "112.0rem"},
        { top: "27rem", left: "104.4375rem"}

      ];
      const keys = ["health", "armor", "stress", "hunger", "water", "oxygen", "id", "clock", "weapon"];

      for (let i = 0; i < keys.length; i++) {
        const savedTop = localStorage.getItem(keys[i] + "PositionTop");
        const savedLeft = localStorage.getItem(keys[i] + "PositionLeft");

        if (savedTop && savedLeft) {
          this.hud[keys[i]].position.top = savedTop;
          this.hud[keys[i]].position.left = savedLeft;
        } else {
          this.hud[keys[i]].position.top = positions[i].top;
          this.hud[keys[i]].position.left = positions[i].left;
          localStorage.setItem(keys[i] + "PositionTop", positions[i].top);
          localStorage.setItem(keys[i] + "PositionLeft", positions[i].left);
        }
      }
    },
    typeSpeedometer(type){
      this.speedStyle = type;
      localStorage.setItem('speedStyle', type);
    },
    loadSettings() {
      const savedSpeedStyle = localStorage.getItem("speedStyle");
      if (savedSpeedStyle) {
        this.speedStyle = savedSpeedStyle;
      }
    },
    typeHud(id){
      this.hudType = id;
      localStorage.setItem('hudType', id);
      $.post(`https://${GetParentResourceName()}/UpStats`, JSON.stringify(), function(data){
        app.hud.hunger.percentage = data.hunger;
        app.hud.water.percentage = data.thirst;
      })
    },
    clickData(type) {
      if (type == "reset") {
        let data = {
          type: "succes",
          header: "Reset",
          description:"Your saved position settings have been set to default!"
        }
        this.addNotification(data)
        const positions = [
          { top: "31.5rem", left: "0.75rem" },     // health
          { top: "35rem", left: "0.75rem" },   // armor
          { top: "35rem", left: "0.75rem" },     // stress
          { top: "38.5rem", left: "0.75rem" },   // hunger
          { top: "42.0rem", left: "0.75rem" },  // water
          { top: "45.5rem", left: "0.75rem" },   // oxygen

          { top: "1.0rem", left: "115.0rem"},  // id
          { top: "1.0rem", left: "101.3125rem" }, // clock
          { top: "8.25rem", left: "108.2969rem"},  // cash
          { top: "11.5625rem", left: "109.8906rem" },  // bank
          { top: "1.0rem", left: "112.0rem"},  // microphone
          { top: "14.875rem", left: "111.4844rem"},  // black
          { top: "18.25rem", left: "104.7rem"},  // job
          { top: "27rem", left: "104.4375rem"},
        ];
        const keys = ["health", "armor", "stress", "hunger", "water", "oxygen", "id", "clock", "cash" , "bank", "microphone", "black", "job", "weapon"];
        for (let i = 0; i < keys.length; i++) {
          this.hud[keys[i]].position.top = positions[i].top;
          this.hud[keys[i]].position.left = positions[i].left;


          localStorage.setItem(keys[i] + "PositionTop", positions[i].top);
          localStorage.setItem(keys[i] + "PositionLeft", positions[i].left);
        }
      }
    },

    getFillColor: function(index, id) {
          let filledBars = Math.ceil(this.hud[id].percentage / 25);
          return index < filledBars ? this.hud[id].color : 'black';
      },

    getFillOpacity: function(index) {
          return index === 0 ? 1 : 1;
    },

    getEdit(type) {
        this.hud[type].drag = !this.hud[type].drag;
        console.log(this.hud[type].drag)
        localStorage.setItem(type + "Drag", this.hud[type].drag);
      },

      getPercentage(min, current) {
        const range = 200 - min;
        const adjustedValue = current - min;
        const percentage = (adjustedValue / range) * 100;
        return percentage;
      },

      updateColor(index, value) {
        const hudItem = this.hud[index];
        if (hudItem) {
          hudItem.color = value;
          localStorage.setItem(`${index}Color`, value);
        } else {
          console.warn(`Invalid index: ${index}`);
        }
      },
      speedSelect(data){
        this.select = data;
      },
      mouseDownHandler: function (style, type, data, e) {
        const drag = e.target.closest('.' + type);
        const rect = drag.getBoundingClientRect();
        const pos = { top: rect.top, left: rect.left, x: e.clientX, y: e.clientY };
        if (type !== 'border') {
          this.hud[data].drag = true;
        }
        const mouseMoveHandler = function (e) {
          const dx = e.clientX - pos.x;
          const dy = e.clientY - pos.y;
          pos.top += dy;
          pos.left += dx;
          if (type !== 'border') {
            const appRect = document.getElementById("app").getBoundingClientRect();
            pos.top = Math.max(appRect.top, Math.min(pos.top, appRect.bottom - drag.offsetHeight));
            pos.left = Math.max(appRect.left, Math.min(pos.left, appRect.right - drag.offsetWidth));
            const elements = document.querySelectorAll('.' + type + '.drag');
            elements.forEach(element => {
              if (element !== drag) {
                const rect = element.getBoundingClientRect();
                const distance = Math.sqrt(Math.pow(pos.left - rect.left, 2) + Math.pow(pos.top - rect.top, 2));
                if (distance < 50) {
                  this.hud[element.dataset.id].drag = true;
                }
              }
            });
          }
          drag.style.top = `${pos.top}px`;
          drag.style.left = `${pos.left}px`;
          pos.x = e.clientX;
          pos.y = e.clientY;
          this.updatePlayerPosition(style, data, pos.top, pos.left);
        }.bind(this);
        const mouseUpHandler = function () {
          document.removeEventListener("mousemove", mouseMoveHandler);
          document.removeEventListener("mouseup", mouseUpHandler);
          if (type !== 'border') {
            const elements = document.querySelectorAll('.' + type + '.drag');
            elements.forEach(element => {
              if (element !== drag) {
                this.hud[element.dataset.id].drag = false;
              }
            });
            this.hud[data].drag = false;
          } else {
            this.hud[data].drag = false;
          }
        }.bind(this);
        document.addEventListener("mousemove", mouseMoveHandler);
        document.addEventListener("mouseup", mouseUpHandler);
      },







      updatePlayerPosition: function (style, data, top, left) {
        if (style === "hud") {
          const dataKey = typeof data === "string" ? data : data.id;
          if (this.hud && this.hud[dataKey]) {
            this.hud[dataKey].position = { top: top + "px", left: left + "px" };
            localStorage.setItem(dataKey + "PositionTop", top + "px");
            localStorage.setItem(dataKey + "PositionLeft", left + "px");
          } else {
            console.error(`Could not find object with id "${dataKey}" in hud`);
          }
        } else {
          const dataKey = typeof data === "string" ? data : data.id;
          if (this.position && this.position[dataKey]) {
            this.position[dataKey] = { top: top + "px", left: left + "px" };
            localStorage.setItem(dataKey + "PositionTop", top + "px");
            localStorage.setItem(dataKey + "PositionLeft", left + "px");
          } else {
            console.error(`Could not find object with id "${dataKey}" in position`);
          }
        }
      },








   },
   mounted() {

    setInterval(() => {
      const now = new Date();
      const hours = now.getHours().toString().padStart(2, '0');
      const minutes = now.getMinutes().toString().padStart(2, '0');
      const day = now.getDate().toString().padStart(2, '0');
      const month = (now.getMonth() + 1).toString().padStart(2, '0');
      const timeString = `${hours}:${minutes}`;
      const dateString = `${day}.${month}`;
      this.player.clock.name = `${timeString} ${dateString}`;
    }, 1000);


    this.loadSettings();
    this.setDefaultPositions();
    const keys = ["health", "armor", "stress", "hunger", "water", "oxygen", "id", "clock", "cash" , "bank", "microphone", "black", "job", "weapon"];
    let isLocalStorageEmpty = false;

    for (let i = 0; i < keys.length; i++) {
      // Eğer localStorage'da bu anahtar için bir veri yoksa, isLocalStorageEmpty'i true olarak ayarla ve döngüyü kır.
      if (!localStorage.getItem(keys[i] + "PositionTop") || !localStorage.getItem(keys[i] + "PositionLeft")) {
        isLocalStorageEmpty = true;
        break;
      }
    }

    // Eğer localStorage boşsa, varsayılan değerleri ayarla.
    if (isLocalStorageEmpty) {
      this.clickData('reset');
    }
  },


  })





  window.addEventListener('message', event => {
    const { action, type, ...data } = event.data;
    const appActions = {
      GET_JOB: () => {
        const { job, grade } = data;
        app.player.job.name = job.charAt(0).toUpperCase() + job.slice(1);
        app.player.job.grade = grade;
      },
      MENU: () => app.hudMenu = true,
      SETCARHUD: () => app.carHud = data.variable,
      CARHUD: () => {
        const { speed, fuel, state, seatbelt, gear, rpm, type } = data;
        Object.assign(app.speedometer, {
          speedh: speed,
          fuel: Math.floor(fuel),
          light: state ? "white" : "gray",
          seatbelt: seatbelt ? "white" : "gray",
          gear
        });
        if (rpm == 16){
          app.vehiclerpm = 3;
        }else {
          app.vehiclerpm = rpm;
        }
        if (type == 'kmh'){
          app.speedHz = 'KM/H'
        }else {
          app.speedHz = 'MPH'
        }
      },
      NOTCAR: () => app.carHud = false,
      HEALTH: () => app.hud.health.percentage = data.health,
      ARMOR: () => app.hud.armor.percentage = data.armor,
      STATUS: () => {
        const { hunger, thirst } = data;
        app.hud.hunger.percentage = hunger;
        app.hud.water.percentage = thirst;
        app.allHud = true;
      },
      UPDATE_NOSS: () => app.speedometer.noss = data.noss,
      EXIT: () => app.allHud = data.args,
      ECONOMY: () => {
        const { cash, bank, black } = data;
        app.player.cash.amount = formatAmount(cash, false);
        app.player.bank.amount = formatAmount(bank, true);
        app.player.black.amount = formatAmount(black, true);
      },
      GET_STAMINA: () => app.hud.oxygen.percentage = data.stamina,
      STRESS: () => app.hud.stress.percentage = data.stress,
      MICROPHONE: () => app.player.microphone.color = data.variable,
      PLAYERS: () => app.player.id.name = data.players,
      GET_WEAPON: () => {
        const { stats, name, img} = data;
        const noSpaceName = name.toLowerCase().split(" ").join("");
        app.player.weapon.variable = stats;
        app.player.weapon.name = name;
        app.player.weapon.img = img;
      },
      GET_AMMO: () => app.player.weapon.ammo = data.ammo,
      GET_NOTIFICATION: () => {
        const { ntype, nheader, nmsg } = data;
        app.addNotification({ type: ntype, header: nheader, description: nmsg });
      },
      GET_QUESTION: () => {
        if (data.qstats) {
          const { qheader, qmsg } = data;
          let ques = { header: qheader, description: qmsg };
          app.question.push(ques);
        } else {
          app.question = [];
        }
      }
    };

    (appActions[action || type] || (() => {}))();
  });





  document.onkeyup = function(data) {
    if (data.which == 27) {
      app.hudMenu = false;
      $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
    }
  };

