(require 'url)
(require 'url-parse)

(defvar youtube-dl-directory "~/Video/YT/")

(defun youtube-dl-get-id (url)
  (let ((query-string (car (last (split-string url "?")))))
    (cadr (assoc "v" (url-parse-query-string query-string)))))

(defun youtube-dl-read-url ()
  (let ((at-point (url-get-url-at-point)))
    (read-string "URL: " nil nil (when at-point (list at-point)))))

(defun youtube-dl-run (command)
  (async-shell-command command))

;;;###autoload
(defun youtube-dl (url)
  (interactive (list (youtube-dl-read-url)))
  (setq url (string-trim url))
  (let* ((default-directory youtube-dl-directory)
         (host (url-host (url-generic-parse-url url)))
         (yt-playlist (when (equal (url-file-nondirectory url) "playlist") url))
         (yt-id (when (string-match-p "y.?o.?u.?t.?u.?b.?e" host) (youtube-dl-get-id url))))
    (cond (yt-playlist
           (youtube-dl-run (format "youtube-dl -f22 '%s' -o '%%(playlist_index)s_%%(title)s.%%(ext)s'" yt-playlist)))
          (yt-id
           (youtube-dl-run (format "youtube-dl -f22 -- '%s'" yt-id)))
          (t
           (youtube-dl-run (format "youtube-dl -f22 -- '%s'" url))))))


