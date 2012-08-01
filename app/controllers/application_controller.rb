class ApplicationController < ActionController::Base
  protect_from_forgery

  JS_ESCAPE_MAP = {
                    '\\'    => '\\\\',
                    '</'    => '<\/',
                    "\r\n"  => '\n',
                    "\n"    => '\n',
                    "\r"    => '\n',
                    '"'     => '\\"',
                    "'"     => "\\'" }

  def escape_javascript(str)
    return str if str.blank?
    str.gsub!(/(\\|<\/|\r\n|[\n\r"'])/) { JS_ESCAPE_MAP[$1] }
    str
  end
end
