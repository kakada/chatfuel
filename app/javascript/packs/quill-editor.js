import ImageResize from "@taoqf/quill-image-resize-module/image-resize.min";
import Quill from "quill/quill";

Quill.register("modules/imageResize", ImageResize);

$(document).on("turbolinks:load", function () {
  if ($("#editor-container")[0]) {
    const COLORS = [
      "#000000",
      "#e60000",
      "#ff9900",
      "#ffff00",
      "#008A00",
      "#0066cc",
      "#9933ff",
      "#ffffff",
      "#facccc",
      "#ffebcc",
      "#ffffcc",
      "#cce8cc",
      "#cce0f5",
      "#ebd6ff",
      "#bbbbbb",
      "#f06666",
      "#ffc266",
      "#ffff66",
      "#66b966",
      "#66a3e0",
      "#c285ff",
      "#888888",
      "#a10000",
      "#b26b00",
      "#b2b200",
      "#006100",
      "#0047b2",
      "#6b24b2",
      "#444444",
      "#5c0000",
      "#663d00",
      "#666600",
      "#003700",
      "#002966",
      "#3d1466",
    ];

    if ($("#editor-container")[0] != undefined) {
      window.quill = new Quill("#editor-container", {
        modules: {
          toolbar: [
            [{ header: [1, 2, 3, 4, 5, 6, false] }],
            [{ color: COLORS }, { background: COLORS }],
            [{ size: [] }],
            [
              "bold",
              "italic",
              "underline",
              "strike",
              { script: "super" },
              { script: "sub" },
              "code",
              "link",
            ],
            ["blockquote", "code-block"],
            [{ list: "ordered" }, { list: "bullet" }],
            [{ align: ["center", "right", "justify", false] }],
            [{ indent: "-1" }, { indent: "+1" }],
          ],
        },
        placeholder: "",
        theme: "snow",
      });
    }
  }

  let $form = $("form");
  if ($form) {
    $form.submit(function (e) {
      if (window.quill != undefined) {
        $(
          "#pdf_template_content, #schedule_pdf_template_attributes_content"
        ).val(window.quill.root.innerHTML);
      }
    });
  }
});

export default Quill;
