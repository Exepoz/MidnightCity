let formInputs = {};
let buttonParams = [];

const OpenMenu = (data) => {
    if (data == null || data == "") {
        console.log("No data detected");
        return null;
    }

    $(`.sd-main-wrapper`).fadeIn(0);

    let form = [
        "<form id='sd-input-form'>",
        `<div class="heading">${ data.header != null ? data.header : "Form Title" }</div>`,
    ];

    data.inputs.forEach((item, index) => {
        switch (item.type) {
            case "text":
                form.push(renderTextInput(item));
                break;
            case "password":
                form.push(renderPasswordInput(item));
                break;
            case "number":
                form.push(renderNumberInput(item));
                break;
            case "radio":
                form.push(renderRadioInput(item));
                break;
            case "select":
                form.push(renderSelectInput(item));
                break;
            case "checkbox":
                form.push(renderCheckboxInput(item));
                break;
            default:
                form.push(`<div>${item.text}</div>`);
        }
    });
    form.push(
        `<div class="footer"><button type="submit" class="btn btn-success" id="submit">${data.submitText ? data.submitText : "Submit"}</button></div>`
    );

    form.push("</form>");

    $(".sd-main-wrapper").html(form.join(" "));

    $("#sd-input-form").on("change", function (event) {
        formInputs[$(event.target).attr("name")] = $(event.target).val();
    });

    $("#sd-input-form").on("submit", async function (event) {
        if (event != null) {
            event.preventDefault();
        }
        let formData = $("#sd-input-form").serializeArray();

        formData.forEach((item, index) => {
            formInputs[item.name] = item.value;
        });

        await $.post(
            `https://${GetParentResourceName()}/buttonSubmit`,
            JSON.stringify({ data: formInputs })
        );
        CloseMenu();
    });
};

const renderTextInput = (item) => {
    const { text, name } = item;
    formInputs[name] = item.default ? item.default : "";
    const isRequired = item.isRequired == "true" || item.isRequired ? "required" : "";
    const defaultValue = item.default ? `value="${item.default}"` : ""

    return ` <input placeholder="${text}" type="text" class="form-control" name="${name}" ${defaultValue} ${isRequired}/>`;
};

const renderPasswordInput = (item) => {
    const { text, name } = item;
    formInputs[name] = item.default ? item.default : "";
    const isRequired = item.isRequired == "true" || item.isRequired ? "required" : "";
    const defaultValue = item.default ? `value="${item.default}"` : ""

    return ` <input placeholder="${text}" type="password" class="form-control" name="${name}" ${defaultValue} ${isRequired}/>`;
};
const renderNumberInput = (item) => {
    try {
        const { text, name } = item;
        formInputs[name] = item.default ? item.default : "";
        const isRequired = item.isRequired == "true" || item.isRequired ? "required" : "";
        const defaultValue = item.default ? `value="${item.default}"` : ""

        return `<input placeholder="${text}" type="number" class="form-control" name="${name}" ${defaultValue} ${isRequired}/>`;
    } catch (err) {
        console.log(err);
        return "";
    }
};

const renderRadioInput = (item) => {
    const { options, name, text } = item;
    formInputs[name] = options[0].value;

    let div = `<div class="form-input-group"> <div class="form-group-title">${text}</div>`;
    div += '<div class="input-group">';
    options.forEach((option, index) => {
        div += `<label for="radio_${name}_${index}"> <input type="radio" id="radio_${name}_${index}" name="${name}" value="${option.value}" 
                ${(item.default ? item.default == option.value : index == 0) ? "checked" : ""}> ${option.text}</label>`;
    });

    div += "</div>";
    div += "</div>";
    return div;
};

const renderCheckboxInput = (item) => {
    const { options, name, text } = item;
    formInputs[name] = options[0].value;

    let div = `<div class="form-input-group"> <div class="form-group-title">${text}</div>`;
    div += '<div class="input-group-chk">';

    options.forEach((option, index) => {
        div += `<label for="chk_${name}_${index}">${option.text} <input type="checkbox" id="chk_${name}_${index}" name="${name}" value="${option.value}" ${option.checked ? 'checked' : ''}></label>`;
        formInputs[option.value] = option.checked ? 'true' : 'false';
    });

    div += "</div>";
    div += "</div>";
    return div;
};

const renderSelectInput = (item) => {
    const { options, name, text } = item;
    let div = `<div class="select-title">${text}</div>`;

    div += `<select class="form-select" name="${name}" title="${text}">`;
    formInputs[name] = options[0].value;

    options.forEach((option, index) => {
        const isDefaultValue = item.default == option.value
        div += `<option value="${option.value}" ${isDefaultValue ? 'selected' : '' }>${option.text}</option>`;
        if(isDefaultValue){ formInputs[name] = option.value }
    });
    div += "</select>";
    return div;
};

const CloseMenu = () => {
    $(`.sd-main-wrapper`).fadeOut(0);
    $("#sd-input-form").remove();
    formInputs = {};
};

const CancelMenu = () => {
    $.post(`https://${GetParentResourceName()}/closeMenu`);
    return CloseMenu();
};

const OpenMenuList = (data = null) => {
    let html = "";
    data.forEach((item, index) => {
        if(!item.hidden) {
            let header = item.header;
            let message = item.txt || item.text;
            let isMenuHeader = item.isMenuHeader;
            let isDisabled = item.disabled;
            let icon = item.icon;
            let isCentered = item.centered;
            html += getButtonRender(header, message, index, isMenuHeader, isDisabled, icon, isCentered);
            if (item.params) buttonParams[index] = item.params;
        }
    });

    $("#buttons").html(html);

    $('.button').click(function() {
        const target = $(this)
        if (!target.hasClass('title') && !target.hasClass('disabled')) {
            postData(target.attr('id'));
        }
    });
};

const getButtonRender = (header, message = null, id, isMenuHeader, isDisabled, icon, isCentered) => {

    if (isCentered) {
        const sample = document.getElementById("container"); 
        sample.style.right = '32.5%';
        sample.style.top = '44%';

    } else {
        const sample = document.getElementById("container"); 
        sample.style.right = '20%';
        sample.style.top = '20%';
    }

    return `
        <div class="${isMenuHeader ? "title" : "button"} ${isDisabled ? "disabled" : ""}" id="${id}">
            <div class="icon"> <i class="${icon}" onerror="this.onerror=null; this.remove();"></i> </div>
            <div class="column">
            <div class="header"> ${header}</div>
            ${message ? `<div class="text">${message}</div>` : ""}
            </div>
        </div>
    `;
};

const CloseMenuList = () => {
    $("#buttons").empty();
    buttonParams = [];
};

const postData = (id) => {
    $.post(`https://${GetParentResourceName()}/clickedButton`, JSON.stringify(parseInt(id) + 1));
    return CloseMenuList();
};

// Optimize the cancelMenuList function
const cancelMenuList = () => {
    $.post(`https://${GetParentResourceName()}/CloseMenuList`);
    return CloseMenuList(); 
};

// Optimize the window message event listener
window.addEventListener("message", (event) => {
    const data = event.data;
    const info = data.data;
    const buttons = data.data; 
    const action = data.action;
    switch (action) {
        case "OPEN_MENU":
            return OpenMenu(info);
        case "CLOSE_MENU":
            return CloseMenu();
        case "OPEN_MENULIST":
        case "SHOW_HEADER":
            return OpenMenuList(buttons);
        case "CLOSE_MENU":
            return CloseMenuList();
        default:
            return;
    }
});

document.onkeyup = function (event) {
    const keyPressed = event.key;
    if (keyPressed === "Enter") {
        SubmitData();
    } 
    if (keyPressed === "Escape") {
        cancelMenuList();
        CancelMenu();
    }
};

$(document).click(function (event) {
    var $target = $(event.target);
    if (!$target.closest(".sd-main-wrapper").length && $(".sd-main-wrapper").is(":visible")) {
        CancelMenu();
    }
});