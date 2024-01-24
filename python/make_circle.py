from PIL import Image
import numpy as np


def process_image(image_path):
    # Load the image
    img = Image.open(image_path).convert("RGBA")

    # Convert to numpy array
    data = np.array(img)
    print(data.shape)

    # Calculate the center of the image
    center_x, center_y = data.shape[1] // 2 - 2, data.shape[0] // 2 + 6

    radius = 285 - 5

    data = data[
        center_y - radius : center_y + radius, center_x - radius : center_x + radius
    ]
    center_x, center_y = data.shape[1] // 2, data.shape[0] // 2

    # Iterate over each pixel
    for y in range(data.shape[0]):
        for x in range(data.shape[1]):
            # Calculate the distance from the center
            distance = np.sqrt((x - center_x) ** 2 + (y - center_y) ** 2)

            # Set alpha to 0 if distance is more than 30 pixels
            if distance > radius:
                data[y, x, 3] = 0
            elif distance < 50:
                #data[y, x] = np.array([255, 255, 0, 255])
                pass
            if np.linalg.norm(data[y, x, :3] - np.array([255, 255, 255])) > 125:
                data[y, x, 3] = 0
                pass

    dx = 220
    dy = 170
    data = data[center_y - 230 : center_y + 140, center_x - 230 : center_x + 230]
    # Convert back to image
    new_img = Image.fromarray(data, "RGBA")

    # Save or display the image
    new_img.save("logo.png")
    new_img.show()


# Replace 'path_to_your_image.jpg' with the path to your image
process_image(
    r"C:\Users\maroun ailabouni\Desktop\flutter\food_menu\python\old.png"
    # r"C:\Users\maroun ailabouni\Desktop\flutter\food_menu\assets\images\BLACK_STORE_BIG_LOGO.jpg"
)
