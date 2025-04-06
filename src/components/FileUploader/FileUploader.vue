<template>
	<div class="file-uploader__container">
		<Heading tag="h2" headingClass="file-uploader__title text--primary font--bold">Subir Archivo</Heading>
		<form @submit.prevent="uploadFile">
			<div 
				:class="{'drop-zone': true, 'dragging': isDragging}" 
				@dragover.prevent="onDragOver" 
				@dragenter.prevent="onDragEnter" 
				@dragleave.prevent="onDragLeave" 
				@drop.prevent="onDrop"
			>
				<p>Arrastra y suelta el archivo aquí o</p>
				<Input 
					type="file" 
					ref="fileInput" 
					@change="onFileChange" 
					:placeholder="filePlaceholder"
					accept=".pdf, .txt, .docx, .md, .doc"
				/>
                <Button type="button" class="trigger-file-button" @click="triggerFileInput">Selecciona un archivo</Button>
				<p :class="{'file-name': true, 'file-name text--primary': fileUploaded}">{{ filePlaceholder }}</p>
			</div>
			<Button type="submit" class="upload-file-button" :disabled="!isFileSelected">Subir archivo</Button>
		</form>
	</div>
</template>

<script>
import Button from '../Button/Button.vue';
import Input from '../Input/Input.vue';
import Heading from '../Heading/Heading.vue';
import { debounce } from 'lodash';
import { EventBus } from '../../eventBus';

export default {
	name: 'FileUploader',
	components: {
		Button,
		Input,
		Heading
	},
	data() {
		return {
			selectedFile: null,
			isDragging: false,
			fileUploaded: false,
			existingFiles: []
		};
	},
	computed: {
		filePlaceholder() {
            return this.fileUploaded ? 'Archivo subido exitosamente' : (this.selectedFile ? this.selectedFile.name : 'Ningún archivo seleccionado');
		},
        isFileSelected() {
            return this.selectedFile !== null;
        }
	},
	methods: {
		triggerFileInput: debounce(function() {
            this.$refs.fileInput.$refs.input.click();
        }, 300),
		onFileChange(event) {
			this.selectedFile = event.target.files[0];
		},
		onDragOver() {
			this.isDragging = true;
		},
		onDragEnter() {
			this.isDragging = true;
		},
		onDragLeave() {
			this.isDragging = false;
		},
		onDrop(event) {
			this.isDragging = false;
			const files = event.dataTransfer.files;
            const allowedTypes = ['application/pdf', 'text/plain', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'text/markdown'];

			if (files.length > 0) {
                const file = files[0];
                if (allowedTypes.includes(file.type)) {
                    this.selectedFile = file;
                    this.$refs.fileInput.value = '';
                } else {
                    alert('Tipo de archivo no soportado. Solo se permiten archivos PDF, TXT, Word o Markdown.');
                }
			}
		},
		async uploadFile() {
			const formData = new FormData();
			const token = sessionStorage.getItem("token");
			await this.fetchExistingFiles(token);

			let fileName = this.selectedFile.name;			
            let baseName = fileName.substring(0, fileName.lastIndexOf('.'));
            let fileExtension = fileName.substring(fileName.lastIndexOf('.'));
            let counter = 1;

			while (this.existingFiles.includes(fileName)) {
                fileName = `${baseName}-${counter}${fileExtension}`;
                counter++;
            }

            formData.append("file", this.selectedFile, fileName);

			try {
				const response = await fetch(`${backendUrl}/documents`, {
					method: "POST",
					headers: {
						"Authorization": `Bearer ${token}`
					},
					body: formData
				});		

				if (!response.ok) {
					throw new Error("Error al subir el archivo");
				}

				this.fileUploaded = true;
				EventBus.emit('file-uploaded');
				setTimeout(() => {
                    this.resetComponent();
                }, 2000);
			} catch (error) {
				console.log(error.message);
			}
		},
        async fetchExistingFiles(token) {
            try {
                const response = await fetch(`${backendUrl}/accounts/documents`, {
                    method: "GET",
                    headers: {
                        "Authorization": `Bearer ${token}`
                    }
                });

                if (!response.ok) {
                    throw new Error("Error al obtener los archivos existentes");
                }

                const data = await response.json();				
                this.existingFiles = data.map(file => file.name);
            } catch (error) {
                console.error(error.message);
            }
        },
        resetComponent() {
            this.selectedFile = null;
            this.isDragging = false;
            this.fileUploaded = false;
        }
	}
};
</script>

<style lang="scss" scoped>
@use './FileUploader.scss';
</style>