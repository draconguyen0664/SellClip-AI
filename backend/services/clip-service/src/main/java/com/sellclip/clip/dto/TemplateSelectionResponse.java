package com.sellclip.clip.dto;

public record TemplateSelectionResponse(
        Boolean ok,
        String message,
        Boolean noTemplate,
        TemplateResponse template
) {
    public static TemplateSelectionResponse blank() {
        return new TemplateSelectionResponse(true, "Đã chọn không dùng template", true, null);
    }

    public static TemplateSelectionResponse saved(TemplateResponse template) {
        return new TemplateSelectionResponse(true, "Đã áp dụng template", false, template);
    }
}
