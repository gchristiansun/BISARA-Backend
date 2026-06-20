import os
import glob
import pickle
import cv2
import numpy as np
import mediapipe as mp
from sklearn.neighbors import KNeighborsClassifier

def train_model():
    print("Initializing MediaPipe HandLandmarker Tasks detector...")
    from mediapipe.tasks import python
    from mediapipe.tasks.python import vision

    MODEL_TASK_PATH = os.path.join(os.path.dirname(__file__), "hand_landmarker.task")
    base_options = python.BaseOptions(model_asset_path=MODEL_TASK_PATH)
    options = vision.HandLandmarkerOptions(
        base_options=base_options,
        running_mode=vision.RunningMode.IMAGE,
        num_hands=1
    )
    detector = vision.HandLandmarker.create_from_options(options)

    # Find the downloaded Kaggle dataset path dynamically
    base_dir = os.path.expanduser("~/.cache/kagglehub/datasets/agungmrf/indonesian-sign-language-bisindo/versions/*")
    versions = glob.glob(base_dir)
    if not versions:
        print("Dataset not found! Please wait for the Kaggle download to complete.")
        return

    dataset_path = max(versions, key=os.path.getmtime)
    print(f"Found dataset path: {dataset_path}")

    # Check for subfolder structure
    train_path = os.path.join(dataset_path, "bisindo", "images", "train")
    if os.path.exists(train_path):
        dataset_path = train_path
        print(f"Directing search to training path: {dataset_path}")

    classes = [d for d in os.listdir(dataset_path) if os.path.isdir(os.path.join(dataset_path, d))]
    print(f"Found {len(classes)} classes to train: {classes}")

    X = []
    y = []
    labels_map = {}

    for label_idx, class_name in enumerate(classes):
        labels_map[label_idx] = class_name
        class_dir = os.path.join(dataset_path, class_name)
        
        # Scan for images
        image_paths = []
        for ext in ['*.jpg', '*.png', '*.jpeg', '*.JPG', '*.PNG']:
            image_paths.extend(glob.glob(os.path.join(class_dir, ext)))
            
        print(f"Processing class '{class_name}' ({len(image_paths)} images)...")
        
        # Limit to 30 images per class for fast, light CPU training
        count = 0
        for img_path in image_paths[:30]:
            img = cv2.imread(img_path)
            if img is None:
                continue
                
            img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=img_rgb)
            results = detector.detect(mp_image)
            
            if results.hand_landmarks:
                landmarks = results.hand_landmarks[0]
                features = []
                for lm in landmarks:
                    features.extend([lm.x, lm.y, lm.z])
                X.append(features)
                y.append(label_idx)
                count += 1
                
        print(f"Extracted landmarks for {count} images in class '{class_name}'")

    if len(X) == 0:
        print("No hand landmarks could be extracted from the dataset! Training aborted.")
        return

    X = np.array(X)
    y = np.array(y)

    print(f"Training KNN Classifier on {len(X)} samples...")
    knn = KNeighborsClassifier(n_neighbors=3)
    knn.fit(X, y)

    # Save model and labels map to pkl file
    model_data = {
        "model": knn,
        "labels": labels_map
    }
    
    output_path = os.path.join(os.path.dirname(__file__), "model_data.pkl")
    with open(output_path, "wb") as f:
        pickle.dump(model_data, f)
        
    print(f"Model successfully trained and saved to: {output_path}!")

if __name__ == "__main__":
    train_model()
