-- CreateTable
CREATE TABLE `avatar` (
    `id` CHAR(26) NOT NULL,
    `image_url` TEXT NULL,
    `name` VARCHAR(100) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `class` (
    `id` CHAR(26) NOT NULL,
    `class_name` VARCHAR(100) NULL,
    `description` TEXT NULL,
    `class_code` VARCHAR(20) NULL,
    `teacher_id` CHAR(26) NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `class_class_code_key`(`class_code`),
    INDEX `teacher_id`(`teacher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `class_member` (
    `id` CHAR(26) NOT NULL,
    `class_id` CHAR(26) NULL,
    `student_id` CHAR(26) NULL,
    `joined_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `student_id`(`student_id`),
    UNIQUE INDEX `class_id`(`class_id`, `student_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `gesture_practice` (
    `id` CHAR(26) NOT NULL,
    `class_id` CHAR(26) NULL,
    `title` VARCHAR(150) NULL,
    `target_gesture` VARCHAR(100) NULL,
    `description` TEXT NULL,

    INDEX `class_id`(`class_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `gesture_result` (
    `id` CHAR(26) NOT NULL,
    `practice_id` CHAR(26) NULL,
    `student_id` CHAR(26) NULL,
    `accuracy_score` FLOAT NULL,
    `result_data` LONGTEXT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `practice_id`(`practice_id`),
    INDEX `student_id`(`student_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `material` (
    `id` CHAR(26) NOT NULL,
    `class_id` CHAR(26) NULL,
    `title` VARCHAR(150) NULL,
    `type` ENUM('text', 'video', 'file') NULL,
    `content` TEXT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    INDEX `class_id`(`class_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `quiz` (
    `id` CHAR(26) NOT NULL,
    `class_id` CHAR(26) NULL,
    `material_id` CHAR(26) NULL,
    `title` VARCHAR(150) NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    INDEX `class_id`(`class_id`),
    INDEX `material_id`(`material_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `quiz_question` (
    `id` CHAR(26) NOT NULL,
    `quiz_id` CHAR(26) NULL,
    `question` TEXT NULL,
    `option_a` TEXT NULL,
    `option_b` TEXT NULL,
    `option_c` TEXT NULL,
    `option_d` TEXT NULL,
    `correct_answer` TEXT NULL,

    INDEX `quiz_id`(`quiz_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `quiz_result` (
    `id` CHAR(26) NOT NULL,
    `quiz_id` CHAR(26) NULL,
    `student_id` CHAR(26) NULL,
    `score` FLOAT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `quiz_id`(`quiz_id`),
    INDEX `student_id`(`student_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `teacher` (
    `id` CHAR(26) NOT NULL,
    `name` VARCHAR(100) NULL,
    `email` VARCHAR(100) NULL,
    `password` VARCHAR(255) NULL,
    `avatar_id` CHAR(26) NULL,
    `refresh_token` TEXT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `email`(`email`),
    INDEX `avatar_id`(`avatar_id`),
    UNIQUE INDEX `refresh_token`(`refresh_token`(191)),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `student` (
    `id` CHAR(26) NOT NULL,
    `name` VARCHAR(100) NULL,
    `student_code` VARCHAR(20) NOT NULL,
    `disability_type` ENUM('tunarungu', 'tunawicara') NULL,
    `avatar_id` CHAR(26) NULL,
    `refresh_token` TEXT NULL,
    `created_at` DATETIME(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NULL,

    UNIQUE INDEX `student_student_code_key`(`student_code`),
    INDEX `avatar_id`(`avatar_id`),
    UNIQUE INDEX `refresh_token`(`refresh_token`(191)),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `class` ADD CONSTRAINT `class_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teacher`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `class_member` ADD CONSTRAINT `class_member_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `class_member` ADD CONSTRAINT `class_member_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `student`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `gesture_practice` ADD CONSTRAINT `gesture_practice_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `gesture_result` ADD CONSTRAINT `gesture_result_ibfk_1` FOREIGN KEY (`practice_id`) REFERENCES `gesture_practice`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `gesture_result` ADD CONSTRAINT `gesture_result_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `student`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `material` ADD CONSTRAINT `material_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `quiz` ADD CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`class_id`) REFERENCES `class`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `quiz` ADD CONSTRAINT `quiz_ibfk_2` FOREIGN KEY (`material_id`) REFERENCES `material`(`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `quiz_question` ADD CONSTRAINT `quiz_question_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `quiz_result` ADD CONSTRAINT `quiz_result_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `quiz_result` ADD CONSTRAINT `quiz_result_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `student`(`id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `teacher` ADD CONSTRAINT `teacher_avatar_fk` FOREIGN KEY (`avatar_id`) REFERENCES `avatar`(`id`) ON DELETE SET NULL ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `student` ADD CONSTRAINT `student_avatar_fk` FOREIGN KEY (`avatar_id`) REFERENCES `avatar`(`id`) ON DELETE SET NULL ON UPDATE RESTRICT;
