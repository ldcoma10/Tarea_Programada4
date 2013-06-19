#gemas utilizadas
require 'sinatra' #Se utilizó Sinatra para poder correr la aplicación utilizando un localhost, para así probar que esta funcione de la manera correcta.
require 'erb' #Embedded Rubí es un sistema de plantillas que incorpora rubí en un documento de texto. A menudo se utiliza para incrustar código Ruby en un HTML documento, similar a ASP , JSP y PHP .  
require 'twitter'#se utilizó para buscar los hashtags al igual que el de instagram.
require 'rubygems'
require 'instagram'#Se utilizó para los hashtags y su información correspondiente

#clase para buscar tweets
#entradas el hashtag y la cantidad de hashtags para buscar
class BuscarTwitter
	def initialize(hash,cant_hash_tags)
	
#claves de acceso de twitter
#oauth=open authorizathion
		Twitter.configure do |twit|
		  twit.consumer_key = '4kX6cEQ1rMfkL9yLfwcqA'
		  twit.consumer_secret = '5Pq8XrycX9piSYn8L62eOXbINcXl35DSJHH1qPgZoc'
		  twit.oauth_token = '1512498554-kx6xdzH0BAexJakyKjIgrqtSAi9cLLNFH2mIyFc'
		  twit.oauth_token_secret = 'X1a75zJynGhoyJZxQoYoLb6mJihMpkd5kQNPwalMAs'
		end
#Se busca los hashtags en twitter
		@busqueda = Twitter.search(hash, :count => cant_hash_tags).results.map do |busqueda1|"#{busqueda1.full_text}%&%#{busqueda1.created_at}%&%#{busqueda1.from_user}%&%#{busqueda1.user.profile_image_url}"
		end
		end
#Se devuelve las respuestas generadas luego de la busqueda
	def retornoBusqueda()
		return @busqueda
	end
	
end

#clase para buscar fotos
#entradas el hashtag y la cantidad de hashtags para buscar
class BuscarInstagram
	def initialize(tag,cant_hash_tags)
	#claves de acceso de twitter
		Instagram.configure do |insta|
		  insta.client_id = '81e3ff65554a4f998e9078709719395c'
		  insta.client_secret = 'd9ab8ee5b0aa4f35a92b06d6fe1b262e'
		end
		@busq=Instagram.tag_recent_media(tag,options={:count=>cant_hash_tags})
	end
	
	def retorno
		return @busq
	end
end


#clase almacenar buscar fotos
#entradas el hashtag y la cantidad de hashtags para buscar
class ListaAlmacenar
	def initialize()
		@Lista=[]
	
	end
	#Se inserta en el atributo lista
	def insertar(texto,timestamp,usuario,fotousuario)
	
		listaobjeto=[texto,timestamp,usuario,fotousuario]
		@Lista+=[listaobjeto]
	end
	#Se imprime los elementos de instagram
	def imprimir
		x=0
		while @Lista.count>x
			puts "----------------------------Twitter----------------------------------"
			puts @Lista[x]
			puts "----------------------------------------------------------------------"
			x=x+1
		end
	end
end



def separarelementos(stringtweets,lista)
	
	len=stringtweets.count
	x=0
	
	while x<len do
		temporal=stringtweets[x].split("%&%")
		lista.insertar(temporal[0],temporal[1],temporal[2],temporal[3])		
		x=x+1
	end
end

def separarelementos1(nuevo)
	
	len=nuevo.count
	x=0
	
	while x<len do
		"----------------------------Instagram----------------------------------"
		puts nuevo[x]
		"------------------------------------------------------------------------"
		x=x+1
	end
end


get '/' do            # Se utiliza para poder llamar a la ventana principal
	erb :principal
end

post '/' do           
	erb :principal
end

post '/resultados' do  # Se imprimen los resultados 
	tag = params[:busqueda].to_s
	num = params[:numtag].to_i
	if (tag!="#") or(tag!="")or (tag!=" ") or (num>0)
		
		$lista=ListaAlmacenar.new
		buscTwit = BuscarTwitter.new(tag,num)
		obtenidos = buscTwit.retornoBusqueda
		separarelementos(obtenidos,$lista) 
		$lista.imprimir
		
		#se eLIMINA EL SIGNO DE # DEBIDO A QUE NO SE ACEPTA PARA LAS BUSQUEDAS ESTE TIPO DE SIGNO
		hash=tag.delete("#")
		buscInsta = BuscarInstagram.new(hash,num)
		obtenidos2=buscInsta.retorno
		separarelementos1(obtenidos2)
	else
		puts 'error'
	end	
	
end
