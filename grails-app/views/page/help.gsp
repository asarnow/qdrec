<%--
  Created by IntelliJ IDEA.
  User: da
  Date: 5/11/13
  Time: 11:33 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <title>Phenome Trainer Help</title>
  <meta name="layout" content="main" />
</head>
<body>
  <div>
    <h2>How to use the Phenome Trainer</h2>
    <p>
      The Phenome Trainer will present you with a series of matched experiment and control images.
      The experimental images are decorated with bounding rectangles which indicate the parasites which were found by the
      computer vision algorithm. These rectangles are <span style="color:#0000ff">blue</span>, which indicates the "normal" classification.
    </p>
    <p>
      Click inside a bounding box to mark a parasite as "degenerate." The bounding box will turn <span style="color:#ff0000">red</span>, reflecting the
      recorded state of that parasite. You can switch a "degenerate" parasite back to "normal" by clicking in the box again.
      This will also toggle the box color back to <span style="color:#0000ff">blue</span>.
    </p>
    <p>
      When you have finished classifying the parasites in an image, click <button class="button">Next</button> to advance to the next image.
      As you advance through the images, your progress will be noted.
    </p>
    <p>
      The Trainer will remember your progress, so if at any time you would like a break from training, just log out.
      When you log in again, you will be able to pick up with the image where you left off.
    </p>
  </div>
</body>
</html>