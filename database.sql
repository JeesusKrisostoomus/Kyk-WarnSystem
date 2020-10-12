DROP TABLE IF EXISTS `user_warnings`;
CREATE TABLE `user_warnings` (
  `id` int(11) AUTO_INCREMENT PRIMARY KEY,
  `source` text DEFAULT NULL,
  `target` text DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `date` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;