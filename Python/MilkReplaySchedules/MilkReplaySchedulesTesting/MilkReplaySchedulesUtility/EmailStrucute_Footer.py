def EmailStructure_Footer(LogDateTime):
    currentYear = str(LogDateTime.strftime("%Y"))
    Footer = "<div class=\"footer\">" \
                "<footer>" \
                    "<small>&copy; Copyright " + currentYear +", CoreCard Software, Inc. All rights reserved</small>" \
                "</footer>" \
            "</div>"

    return Footer
