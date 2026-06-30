package com.sellclip.clip.entity;

public enum AspectRatio {
    RATIO_9_16("9:16"),
    RATIO_1_1("1:1"),
    RATIO_4_5("4:5"),
    RATIO_16_9("16:9");

    private final String label;

    AspectRatio(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
